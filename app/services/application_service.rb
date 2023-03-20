# frozen_string_literal: true

class ApplicationService
  def initialize(params)
    @params = params
    params.each { |k, v| self.instance_variable_set("@#{k}", v)}
  end
end
