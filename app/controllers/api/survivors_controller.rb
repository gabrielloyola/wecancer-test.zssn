class Api::SurvivorsController < ApplicationController
  def index
    survivors = Survivor.all

    render json: SurvivorSerializer.new(survivors).serializable_hash.to_json
  end

  def create
    created_survivor = SurvivorServices::Creator.new(*create_params).call

    render json: SurvivorSerializer.new(created_survivor).serializable_hash.to_json, status: :created
  end

  def show
    survivor = SurvivorServices::Shower.new(*show_params).call

    return render json: nil, status: :not_found unless survivor

    render json: SurvivorSerializer.new(survivor).serializable_hash.to_json
  end

  def update_location
    success = SurvivorServices::LocationUpdater.new(*update_location_params).call

    return render json: nil, status: :unprocessable_entity unless success

    render json: nil, status: :no_content
  end

  private

  def create_params
    required_params = %i[name age gender]
    permitted_params = %i[last_lat last_long]

    params.require(required_params)

    params.permit(permitted_params.concat(required_params))
  end

  def show_params
    required_params = %i[survivor_id]

    params.require(required_params)

    params.permit(required_params)
  end

  def update_location_params
    required_params = %i[survivor_id last_lat last_long]

    params.require(required_params)

    params.permit(required_params)
  end
end
