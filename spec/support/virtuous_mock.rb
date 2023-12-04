require 'sinatra/base'
require 'securerandom'
require_relative 'fixtures_helper'

class VirtuousMock < Sinatra::Base
  # GET requests
  {
    contact: 'Contact/Find',
    individual: 'ContactIndividual/Find'
  }.each do |json, end_point|
    get "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    FixturesHelper.read(file_name)
  end
end
