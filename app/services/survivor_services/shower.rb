# frozen_string_literal: true

module SurvivorServices
  class Shower < ApplicationService
    def call
      find_survivor
    end

    private

    def find_survivor
      Survivor.find(@survivor_id)
    rescue ActiveRecord::RecordNotFound
    end
  end
end
