require 'rails_helper'

RSpec.describe 'Api::Survivors', type: :request do
  describe 'GET /api/survivors/' do
    context 'when no one is registered' do
      it 'returns an empty array' do
        get '/api/survivors/'

        expect(response).to be_successful
        expect(json_response['data']).to be_empty
      end
    end

    context 'when there is survivors registered' do
      let(:survivors_count) { 5 }

      before { create_list(:survivor, survivors_count) }

      it 'returns an array with survivors data' do
        get '/api/survivors/'

        expect(response).to be_successful
        expect(json_response['data'].count).to be(survivors_count)
      end
    end
  end

  describe 'GET /api/survivors/:survivor_id' do
    context 'when survivor exists' do
      let(:survivor) { create(:survivor) }

      it 'returns survivor data' do
        get "/api/survivors/#{survivor.id}"

        expect(response).to be_successful
        expect(json_response['data']['id'].to_i).to eq(survivor.id)
      end
    end

    context 'when the id is incorrect' do
      let(:survivor) { create(:survivor) }

      it 'returns not found error' do
        get "/api/survivors/#{survivor.id}12"

        expect(response).to be_not_found
      end
    end
  end

  describe 'POST /api/survivors/' do
    context 'when all required attributes are present' do
      let(:params) do
        {
          name: Faker::Name.name,
          age: 21,
          gender: 'male'
        }
      end

      before { post '/api/survivors/', params: params }

      it 'creates successfully' do
        expect(response).to be_successful
        expect(json_response['data']['id']).to be_present
      end

      it 'returns the correct data' do
        expect(response_attributes['name']).to eq(params[:name])
        expect(response_attributes['age'].to_i).to eq(params[:age])
        expect(response_attributes['gender']).to eq(params[:gender])
      end
    end

    context 'when the survivor has a location' do
      let(:params) do
        {
          name: Faker::Name.name,
          age: 21,
          gender: 'male',
          last_lat: Faker::Number.decimal(l_digits: 3, r_digits: 5),
          last_long: Faker::Number.decimal(l_digits: 3, r_digits: 5)
        }
      end

      before { post '/api/survivors/', params: params }

      it 'creates successfully' do
        expect(response).to be_successful
        expect(json_response['data']['id']).to be_present
      end

      it 'returns the formatted location' do
        expect(response_attributes['last_location']).to eq("#{params[:last_lat]}, #{params[:last_long]}")
      end
    end

    shared_examples 'without any required parameter' do
      it 'fails with unprocessable_entity' do
        expect { post '/api/survivors/', params: params }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'when name attribute is missing' do
      let(:params) do
        {
          age: 21,
          gender: 'male'
        }
      end

      it_behaves_like 'without any required parameter'
    end

    context 'when age attribute is missing' do
      let(:params) do
        {
          name: Faker::Name.name,
          gender: 'male'
        }
      end

      it_behaves_like 'without any required parameter'
    end

    context 'when gender attribute is missing' do
      let(:params) do
        {
          name: Faker::Name.name,
          age: 21
        }
      end

      it_behaves_like 'without any required parameter'
    end
  end

  describe 'PATCH /api/survivors/:survivor_id/location' do
    let!(:survivor) { create(:survivor) }
    let(:request_call) { patch "/api/survivors/#{survivor_id}/location", params: params }

    context 'when the parameters are correct' do
      let(:survivor_id) { survivor.id }
      let(:params) do
        {
          last_lat: Faker::Number.decimal(l_digits: 3, r_digits: 5),
          last_long: Faker::Number.decimal(l_digits: 3, r_digits: 5)
        }
      end

      before { request_call }

      it 'returns success' do
        expect(response).to be_successful
      end
    end

    context 'when the id is incorrect' do
      let(:survivor_id) { survivor.id + 5 }
      let(:params) do
        {
          last_lat: Faker::Number.decimal(l_digits: 3, r_digits: 5),
          last_long: Faker::Number.decimal(l_digits: 3, r_digits: 5)
        }
      end

      before { request_call }

      it 'returns unprocessable entity error' do
        expect(response.status).to eq(422)
      end
    end

    shared_examples 'without any required parameter' do
      it 'fails with unprocessable_entity' do
        expect { request_call }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'when last_lat is missing' do
      let(:survivor_id) { survivor.id }
      let(:params) do
        {
          last_long: Faker::Number.decimal(l_digits: 3, r_digits: 5)
        }
      end

      it_behaves_like 'without any required parameter'
    end

    context 'when last_lat is missing' do
      let(:survivor_id) { survivor.id }
      let(:params) do
        {
          last_lat: Faker::Number.decimal(l_digits: 3, r_digits: 5)
        }
      end

      it_behaves_like 'without any required parameter'
    end
  end
end
