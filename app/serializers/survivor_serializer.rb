class SurvivorSerializer
  include JSONAPI::Serializer

  attributes :name, :age, :gender

  attribute :last_location do |object|
    next if object.last_lat.nil? && object.last_long.nil?

    "#{object.last_lat}, #{object.last_long}"
  end
end
