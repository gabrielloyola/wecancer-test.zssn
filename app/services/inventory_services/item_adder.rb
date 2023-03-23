# frozen_string_literal: true

module InventoryServices
  class ItemAdder < ApplicationService
    def call
      return [nil, 'This survivor is infected!'] if survivor.infected?

      add_item!

      inventory_item
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      [nil, e.message]
    end

    private

    def add_item!
      result = inventory_item.update!(quantity: inventory_item.quantity + quantity_to_add.to_i)
    end

    def item
      @item ||= Item.find_by!(name: @item_name)
    end

    def inventory_item
      @inventory_item ||= InventoryItem.find_by!(item: item, survivor: survivor)
    end

    def survivor
      @survivor ||= Survivor.find(@survivor_id)
    end

    def quantity_to_add
      # Take from parameter or use 1 as default
      @quantity ||= 1
    end
  end
end
