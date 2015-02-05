require 'json'
require 'ostruct'

module ApiHelper

  def parse(output)
    ::JSON.parse(output)
  end

  def parse_body
    parse @response.body
  end


  def to_object(hash)
    ::OpenStruct.new(hash)
  end
end
