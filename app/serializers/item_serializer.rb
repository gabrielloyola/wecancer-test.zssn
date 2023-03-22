class ItemSerializer
  include JSONAPI::Serializer

  attributes :name, :value

  has_many :inventory_items
end
