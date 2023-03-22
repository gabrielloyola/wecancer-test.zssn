# frozen_string_literal: true

module InventoryServices
  class ItemRemover < ApplicationService
    def call
      return [nil, 'This survivor is infected!'] if survivor.infected?

      return remove_item! if inventory_item.quantity.positive?

      [nil, 'Can\'t remove this item because you don\'t have any of it']
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      [nil, e.message]
    end

    private

    def remove_item!
      inventory_item.update!(quantity: inventory_item.quantity - 1)

      inventory_item
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
