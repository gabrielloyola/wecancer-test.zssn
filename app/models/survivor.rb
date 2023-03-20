class Survivor < ApplicationRecord
  has_many :infection_reports, inverse_of: :infected, foreign_key: 'infected_id'

  validates_presence_of :name, :age, :gender

  def flag_infection
    return unless infection_reports.count > 2

    update!(infected: true)
  end
end
