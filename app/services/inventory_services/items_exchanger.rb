# frozen_string_literal: true

module InventoryServices
  class ItemsExchanger < ApplicationService
    def call
      errors = validate_exchange
      return [false, errors] if errors.any?

      exchange_items
    rescue ActiveRecord::RecordNotFound => e
      [false, e.message]
    end

    private

    def validate_exchange
      errors = []

      errors << 'One of the survivors is infected. Aborting.' if any_infected?

      errors << 'Insuficient resources for this exchange.' if any_lack_of_resource?

      if bag_points[0] != bag_points[1]
        errors << "Bag points doesn\'t match. Bag #1: #{bag_points[0]} - Bag #2: #{bag_points[1]}"
      end

      errors
    end

    def exchange_items
      transfer_items(@bags[0], @bags[1])
      transfer_items(@bags[1], @bags[0])

      true
    end

    def transfer_items(origin, destination)
      origin[:items].each do |item|
        InventoryServices::ItemRemover.new({
          survivor_id: origin[:survivor_id],
          item_name: item[:name],
          quantity: item[:quantity]
        }).call

        InventoryServices::ItemAdder.new({
          survivor_id: destination[:survivor_id],
          item_name: item[:name],
          quantity: item[:quantity]
        }).call
      end
    end

    def any_infected?
      @bags.any? { |bag| Survivor.find(bag[:survivor_id]).infected? }
    end

    def any_lack_of_resource?
      @bags.any? do |bag|
        bag[:items].any? do |item|
          inventory_item = inventory_item_by(survivor_id: bag[:survivor_id], item_name: item[:name])

          (inventory_item.quantity - item[:quantity].to_i).negative?
        end
      end
    end

    def bag_points
      @bag_points ||= @bags.map { |bag| points_from(bag[:items]) }
    end

    def points_from(items)
      items.sum do |item|
        Item.find_by!(name: item[:name]).value * item[:quantity].to_i
      end
    end

    def inventory_item_by(survivor_id:, item_name:)
      InventoryItem.includes(:item).find_by!(survivor_id: survivor_id, item: { name: item_name })
    end
  end
end
