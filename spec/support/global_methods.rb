def json_response
  JSON.parse(response.body)
end

def response_attributes
  json_response['data']['attributes']
end
