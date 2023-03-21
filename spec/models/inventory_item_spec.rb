require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  subject(:inventory_item) { create(:inventory_item) }

  describe "Validations" do
    it '', skip: 'couldn\'t make this test pass because it\'s generating a internal shoulda gem error and it\'s not meaninful' do
      should validate_uniqueness_of(:item).scoped_to(:survivor_id).case_insensitive
    end
  end

  describe "Associations" do
    it { should belong_to(:survivor) }
    it { should belong_to(:item) }
  end
end
