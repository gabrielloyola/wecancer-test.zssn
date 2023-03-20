class Api::InfectionsController < ApplicationController
  def report_infected
    success, message = InfectionServices::Reporter.new(report_infected_params).call

    return render json: { message: message }, status: :unprocessable_entity unless success

    render json: nil, status: :no_content
  end

  private

  def report_infected_params
    required_params = %i[reporter_id infected_id]

    params.require(required_params)

    params.permit(required_params)
  end
end
