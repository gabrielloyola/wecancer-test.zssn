class InfectionReportSerializer
  include JSONAPI::Serializer

  belongs_to :reporter, serializer: :survivor
  belongs_to :infected, serializer: :survivor
end
