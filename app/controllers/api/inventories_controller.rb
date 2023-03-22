class Api::InventoriesController < ApplicationController
  def add_item
    inventory_item, message = InventoryServices::ItemAdder.new(add_or_remove_item_params).call

    return render json: { message: message }, status: :unprocessable_entity unless inventory_item.present?

    render json: InventoryItemSerializer.new(inventory_item).serializable_hash.to_json
  end

  def remove_item
    inventory_item, message = InventoryServices::ItemRemover.new(add_or_remove_item_params).call

    return render json: { message: message }, status: :unprocessable_entity unless inventory_item.present?

    render json: InventoryItemSerializer.new(inventory_item).serializable_hash.to_json
  end

  private

  def add_or_remove_item_params
    required_params = %i[survivor_id item_name]

    params.require(required_params)

    params.permit(required_params)
  end
end
