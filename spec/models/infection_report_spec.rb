require 'rails_helper'

RSpec.describe InfectionReport, type: :model do
  subject(:infection_report) { build(:infection_report) }

  describe "validations" do
    it { should validate_presence_of(:reporter) }
    it { should validate_presence_of(:infected) }

    describe 'infected uniqueness in reporter scope' do
      before do
        existing_report = create(:infection_report)
        infection_report.infected = existing_report.infected
        infection_report.reporter = existing_report.reporter
      end

      it { expect(infection_report).not_to be_valid }

      it 'contains error messages' do
        infection_report.save
        expect(infection_report.errors.messages).to eq({ infected: ['has already been taken'] })
      end
    end

    describe 'hooks' do
      let(:infected) { build(:survivor) }

      describe 'flag_infection in after_save' do
        before do
          allow(infected).to receive(:flag_infection)
          infection_report.infected = infected
        end

        it 'calls \'flag_infection\' method for the reported survivor' do
          infection_report.save
          expect(infected).to have_received(:flag_infection).once
        end
      end
    end
  end
end
