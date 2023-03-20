require 'rails_helper'

RSpec.describe Survivor, type: :model do
  subject(:survivor) { create(:survivor) }

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:gender) }
  end

  describe "Associations" do
    it { should have_many(:infection_reports).inverse_of(:infected) }
  end

  describe "#flag_infection" do
    context 'with more than 2 infection reports' do
      before do
        create_list(:infection_report, 3, infected_id: survivor.id)
      end

      it 'changes infected flag to true' do
        expect(survivor.reload.infected).to be_truthy
      end
    end

    context 'with less than 3 infection reports' do
      before do
        create_list(:infection_report, 2, infected_id: survivor.id)
      end

      it 'changes infected flag to true' do
        expect(survivor.reload.infected).to be_falsy
      end
    end
  end
end
