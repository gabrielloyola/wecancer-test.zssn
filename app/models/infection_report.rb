class InfectionReport < ApplicationRecord
  belongs_to :reporter, class_name: 'Survivor', foreign_key: 'reporter_id'
  belongs_to :infected, class_name: 'Survivor', foreign_key: 'infected_id'

  validates_presence_of :reporter, :infected
  validates :infected, uniqueness: { scope: :reporter }

  after_save :flag_infection

  def flag_infection
    infected.flag_infection
  end
end
