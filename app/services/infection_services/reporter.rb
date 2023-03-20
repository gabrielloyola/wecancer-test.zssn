# frozen_string_literal: true

module InfectionServices
  class Reporter < ApplicationService
    def call
      return report_infected! if can_be_reported?

      [false, 'Survivor can\'t be reported.']
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      [false, e.message]
    end

    private

    def report_infected!
      InfectionReport.create!(@params)
    end

    def can_be_reported?
      reporter.present? &&
        !reporter.infected &&
        infected.present?
    end

    def reporter
      @reporter ||= Survivor.find(@reporter_id)
    end

    def infected
      @infected ||= Survivor.find(@infected_id)
    end
  end
end
