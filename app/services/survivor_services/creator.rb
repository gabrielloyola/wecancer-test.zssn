# frozen_string_literal: true

module SurvivorServices
  class Creator < ApplicationService
    def call
      create_survivor!
    end

    private

    def create_survivor!
      Survivor.create!(@params)
    end
  end
end
