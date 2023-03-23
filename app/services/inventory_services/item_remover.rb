# frozen_string_literal: true

module InventoryServices
  class ItemRemover < ApplicationService
    def call
      return [nil, 'This survivor is infected!'] if survivor.infected?

      return remove_items! if is_quantity_enough?

      [nil, 'Can\'t remove this item because you don\'t have any of it']
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      [nil, e.message]
    end

    private

    def remove_items!
      inventory_item.update!(quantity: inventory_item.quantity - quantity_to_remove.to_i)

      inventory_item
    end

    def is_quantity_enough?
      !(inventory_item.quantity - quantity_to_remove.to_i).negative?
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

    def quantity_to_remove
      # Take from parameter or use 1 as default
      @quantity ||= 1
    end
  end
end
