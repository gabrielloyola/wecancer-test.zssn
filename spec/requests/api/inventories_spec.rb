require 'rails_helper'

RSpec.describe 'Api::Inventories', type: :request do
  shared_examples 'successfully changing the items quantity' do |new_quantity|
    before { request_call }

    it 'returns success and add 1 to inventory_item\'s quantity' do
      expect(inventory_item.reload.quantity).to be(new_quantity)
      expect(response).to be_successful
    end
  end

  shared_examples 'failing to change items quantity' do |total_items|
    before { request_call }

    it 'returns unprocessable entity' do
      expect(response).to have_http_status(422)
      expect(json_response['message']).to eq('Couldn\'t find Item')
    end

    it 'doesn\'t change the items count' do
      expect(survivor.inventory_items.sum(&:quantity)).to be(total_items)
    end
  end

  shared_examples 'not allowed to manage the inventory' do
    before { request_call }

    it 'returns unprocessable entity' do
      expect(response).to have_http_status(422)
      expect(json_response['message']).to eq('This survivor is infected!')
    end
  end

  shared_examples 'not possible to do the exchange' do
    before do
      request_call
    end

    it 'returns unprocessable entity' do
      expect(response).to have_http_status(422)
      expect(json_response['message']).to include(expected_error)
    end
  end

  describe 'PUT /api/inventories/:survivor_id/add' do
    let(:survivor) { create(:survivor, :with_inventory_items) }
    let(:request_call) { put "/api/inventories/#{survivor.id}/add", params: params }
    let(:params) do
      {
        item_name: item_name
      }
    end

    let(:inventory_item) { survivor.inventory_items.first }
    let(:item_name) { inventory_item.item.name }

    context 'when item is findable by given item_name' do

      it_behaves_like 'successfully changing the items quantity', 1
    end

    context 'when item is not findable by item_name parameter' do
      let(:item_name) { 'Ice cream' }

      it_behaves_like 'failing to change items quantity', 0
    end

    context 'when the survivor is infected' do
      let(:survivor) { create(:survivor, :infected, :with_inventory_items) }

      it_behaves_like 'not allowed to manage the inventory'
    end
  end

  describe 'PUT /api/inventories/:survivor_id/remove' do
    let(:survivor) { create(:survivor, :with_inventory_items, item_quantity: 1) }
    let(:request_call) { put "/api/inventories/#{survivor.id}/remove", params: params }
    let(:params) do
      {
        item_name: item_name
      }
    end

    let(:inventory_item) { survivor.inventory_items.first }
    let(:item_name) { inventory_item.item.name }

    context 'when item is findable by given item_name' do
      it_behaves_like 'successfully changing the items quantity', 0
    end

    context 'when item is not findable by item_name parameter' do
      let(:item_name) { 'Ice cream' }

      it_behaves_like 'failing to change items quantity', 2
    end

    context 'when the survivor is infected' do
      let(:survivor) { create(:survivor, :infected, :with_inventory_items) }

      it_behaves_like 'not allowed to manage the inventory'
    end

    context 'when the survivor doesn\'t have any item of provided item_name' do
      let(:survivor) { create(:survivor, :with_inventory_items) }

      before { request_call }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(422)
        expect(json_response['message']).to eq('Can\'t remove this item because you don\'t have any of it')
      end
    end
  end

  describe 'POST /api/inventories/exchange' do
    let(:request_call) { post '/api/inventories/exchange', params: params }
    let(:survivors) { create_pair(:survivor) }
    let(:items) { create_pair(:item, value: 2) }
    let(:params) do
      {
        bags: [
          {
            survivor_id: survivors.first.id,
            items: [
              {
                name: items.first.name,
                quantity: 1
              }
            ]
          },
          {
            survivor_id: survivors.last.id,
            items: [
              {
                name: items.last.name,
                quantity: 1
              }
            ]
          }
        ]
      }
    end

    before do
      survivors.each do |survivor|
        items.each do |item|
          create(:inventory_item, :one, item: item, survivor: survivor)
        end
      end
    end

    context 'when one of them is infected' do
      let(:expected_error) { 'One of the survivors is infected. Aborting.' }

      before do
        survivors.first.update!(infected: true)
      end

      it_behaves_like 'not possible to do the exchange'
    end

    context 'when one of survivors doesn\'t have suficient resources' do
      let(:expected_error) { 'Insuficient resources for this exchange.' }

      before do
        survivors.first
          .inventory_items
          .includes(:item)
          .find_by(item: { name: items.first.name })
          .update!(quantity: 0)

        request_call
      end

      it_behaves_like 'not possible to do the exchange'
    end

    context 'when the bags total points doesn\'t match' do
      let(:expected_error) { /Bag points doesn\'t match./ }

      before do
        items.first.update!(value: 15)

        request_call
      end

      it_behaves_like 'not possible to do the exchange'
    end

    context 'when it\'s possible to do the exchange' do
      before { request_call }

      it { expect(response).to be_successful }

      it 'removes from the inventories' do
        first_inventory_item = survivors.first.inventory_items.find_by(item: items.first)
        second_inventory_item = survivors.second.inventory_items.find_by(item: items.second)

        expect(first_inventory_item.quantity).to be_zero
        expect(second_inventory_item.quantity).to be_zero
      end

      it 'add to the other inventory' do
        first_inventory_item = survivors.second.inventory_items.find_by(item: items.first)
        second_inventory_item = survivors.first.inventory_items.find_by(item: items.second)

        expect(first_inventory_item.quantity).to be(2)
        expect(second_inventory_item.quantity).to be(2)
      end
    end
  end
end
