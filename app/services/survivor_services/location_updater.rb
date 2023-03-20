# frozen_string_literal: true

module SurvivorServices
  class LocationUpdater < ApplicationService
    def call
      update_location!
    rescue ActiveRecord::RecordNotFound
      false
    end

    private

    def update_location!
      survivor.update!(@params.except(:survivor_id))
    end

    def survivor
      @survivor ||= Survivor.find(@survivor_id)
    end
  end
end
