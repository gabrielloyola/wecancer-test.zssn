class Item < ApplicationRecord
  has_many :inventory_items, dependent: :destroy

  validates_presence_of :name, :value
  validates_uniqueness_of :name
end
