class InventoryItem < ApplicationRecord
  belongs_to :survivor
  belongs_to :item

  validates :item, uniqueness: { scope: :survivor }
end
