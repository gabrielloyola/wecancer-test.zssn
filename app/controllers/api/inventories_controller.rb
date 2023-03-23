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

  def exchange_items
    success, message = InventoryServices::ItemsExchanger.new(exchange_items_params).call

    return render json: { message: message }, status: :unprocessable_entity unless success

    render json: nil, status: :no_content
  rescue ActionController::UnpermittedParameters => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def add_or_remove_item_params
    required_params = %i[survivor_id item_name]
    permitted_params = %i[quantity]

    params.require(required_params)

    params.permit(permitted_params.concat(required_params))
  end

  def exchange_items_params
    permitted_params = [
      bags: [
        :survivor_id,
        items: %i[name quantity]
      ]
    ]

    params.permit(permitted_params)
  end
end
