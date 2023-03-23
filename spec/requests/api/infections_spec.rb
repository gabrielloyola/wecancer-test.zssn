require 'rails_helper'

RSpec.describe "Api::Infections", type: :request do
  let(:request_call) { post "/api/infections/#{infected.id}/report", params: params }
  let(:params) do
    {
      reporter_id: reporter.id
    }
  end

  describe "POST /api/infections/:infected_id/report" do
    let(:survivors) { create_list(:survivor, 5) }
    let(:reporter) { survivors.first }
    let(:infected) { survivors.last }

    context 'when the reporter indicates someone valid for the first time' do

      it 'register the infection' do
        expect { request_call }.to change { infected.infection_reports.count }.by(1)

        expect(response).to be_successful
      end
    end

    shared_examples 'don\'t register the infection report' do
      it 'returns unprocessable entity with an error message' do
        expect { request_call }.not_to change { infected.infection_reports.count }
        expect(response).to have_http_status(422)
        expect(json_response['message']).to eq(expected_error_message)
      end
    end

    context 'when the reporter already indicated that infected' do
      let(:expected_error_message) { 'Validation failed: Infected has already been taken' }

      before { create(:infection_report, reporter_id: reporter.id, infected_id: infected.id) }

      it_behaves_like 'don\'t register the infection report'
    end

    context 'when the infected_id is not valid' do
      let(:wrong_id) { infected.id + 100 }
      let(:expected_error_message) { "Couldn't find Survivor with 'id'=#{wrong_id}" }

      let(:request_call) { post "/api/infections/#{wrong_id}/report", params: params }

      it_behaves_like 'don\'t register the infection report'
    end

    context 'when the reporter_id is not valid' do
      let(:wrong_id) { reporter.id + 100 }
      let(:expected_error_message) { "Couldn't find Survivor with 'id'=#{wrong_id}" }

      let(:params) do
        {
          reporter_id: wrong_id
        }
      end

      it_behaves_like 'don\'t register the infection report'
    end

    context 'when the reporter is infected' do
      let(:wrong_id) { reporter.id + 100 }
      let(:expected_error_message) { 'Survivor can\'t be reported.' }

      before { reporter.update!(infected: true) }

      it_behaves_like 'don\'t register the infection report'
    end
  end

  describe 'Infection confirmation' do
    let(:survivors) { create_list(:survivor, 5) }

    let(:reporter) { survivors.first }
    let(:infected) { survivors.last }

    context 'when the infected is been reported for the third time' do
      before do
        create(:infection_report, reporter_id: survivors[1].id, infected_id: infected.id)
        create(:infection_report, reporter_id: survivors[2].id, infected_id: infected.id)
      end

      it 'updates the \'infected\' flag of reported survivor' do
        expect { request_call }.to change { infected.reload.infected }.from(false).to(true)
      end
    end

    context 'when the infected has less than 3 infection reports' do
      let(:reporter) { survivors.first }
      let(:reported) { survivors.last }

      it 'updates the \'infected\' flag of reported survivor' do
        expect { request_call }.not_to change { infected.infected }
      end
    end
  end
end
