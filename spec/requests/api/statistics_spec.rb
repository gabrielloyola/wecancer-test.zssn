require 'rails_helper'

RSpec.describe "Api::Statistics", type: :request do
  describe "GET /api/statistics" do
    let(:survivors) { create_list(:survivor, 10) }
    let(:request_call) { get '/api/statistics' }

    describe 'infected percentage' do
      let(:infected_number) { 2 }

      before do
        survivors.take(infected_number).each { |survivor| survivor.update!(infected: true) }

        request_call
      end

      it 'returns the infected percentage' do
        expect(response).to be_successful
        expect(json_response['infected_percentage']).to be(infected_number.to_f / survivors.count * 100)
      end

      it 'returns the percentage of not infected survivors' do
        expect(json_response['not_infected_percentage']).to be((survivors.count - infected_number).to_f / survivors.count * 100)
      end
    end

    describe 'items average' do
      let!(:items) { create_pair(:item) }
      let(:survivors) { create_pair(:survivor) }
      let(:quantities) { [12, 7] }

      before do
        items.each_with_index do |item, index|
          survivors.first.inventory_items.find_by(item: item).update!(quantity: quantities[index])
        end
      end

      it 'returns the items average per survivor indicated by item_name' do
        request_call
        expect(json_response['item_averages']["#{items.first.name}"].to_f).to be(quantities.first / survivors.count.to_f)
        expect(json_response['item_averages']["#{items.last.name}"].to_f).to be(quantities.last / survivors.count.to_f)
      end

      context 'when one survivor is infected' do
        before do
          survivors.last.update!(infected: true)

          request_call
        end

        it 'won\'t consider in average' do
          expect(json_response['item_averages']["#{items.first.name}"].to_f).to be(quantities.first.to_f)
          expect(json_response['item_averages']["#{items.last.name}"].to_f).to be(quantities.last.to_f)
        end
      end
    end

    describe 'points lost by infected survivors' do
      let!(:item) { create(:item, value: 2) }
      let(:survivors) { create_list(:survivor, 10, :with_inventory_items, item_quantity: 5) }
      let(:infected) { create_list(:survivor, 2, :infected) }

      before do
        infected.each { |inf| inf.inventory_items.first.update!(quantity: 1) }

        request_call
      end

      it 'returns the points from infected\'s inventory items' do
        expect(json_response['lost_infected_points']).to be(infected.count * item.value)
      end
    end
  end
end
