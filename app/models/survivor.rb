class Survivor < ApplicationRecord
  has_many :infection_reports, inverse_of: :infected, foreign_key: 'infected_id'
  has_many :inventory_items

  validates_presence_of :name, :age, :gender

  after_create :create_inventory_items

  def flag_infection
    return unless infection_reports.count > 2

    update!(infected: true)
  end

  def create_inventory_items
    Item.all.each do |item|
      InventoryItem.create(item: item, survivor: self)
    end
  end
end
