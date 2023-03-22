class InventoryItemSerializer
  include JSONAPI::Serializer

  attributes :quantity

  belongs_to :item
  belongs_to :survivor
end
