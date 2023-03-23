class Api::StatisticsController < ApplicationController
  def generate
    statistics = StatisticServices::Generator.new({}).call

    render json: statistics
  end
end
