require 'rails_helper'

RSpec.describe Survivor, type: :model do
  subject { build(:survivor) }

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:gender) }
  end
end
