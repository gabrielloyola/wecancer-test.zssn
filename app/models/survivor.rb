class Survivor < ApplicationRecord
  validates_presence_of :name, :age, :gender
end
