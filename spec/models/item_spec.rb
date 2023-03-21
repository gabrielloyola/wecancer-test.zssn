require 'rails_helper'

RSpec.describe Item, type: :model do
  subject(:item) { create(:item) }

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value) }

    it { should validate_uniqueness_of(:name) }
  end

  describe "Associations" do
    it { should have_many(:inventory_items) }
  end
end
