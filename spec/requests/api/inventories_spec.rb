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

  describe 'PUT /api/inventories/:survivor_id/add' do
    let(:survivor) { create(:survivor, :with_inventory_items) }
    let(:request_call) { put "/api/inventory/#{survivor.id}/add", params: params }
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
    let(:request_call) { put "/api/inventory/#{survivor.id}/remove", params: params }
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
end
