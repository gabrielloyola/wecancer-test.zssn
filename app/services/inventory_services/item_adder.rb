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
      inventory_item.update!(quantity: inventory_item.quantity + 1)
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
  end
end
