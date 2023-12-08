require 'sinatra/base'
require 'securerandom'
require_relative 'fixtures_helper'

class VirtuousMock < Sinatra::Base
  # GET requests
  {
    'Contact/Find' => :contact,
    'Contact/:id' => :contact,
    'ContactIndividual/Find' => :individual,
    'ContactIndividual/:id' => :individual,
    'Gift/ByContact/:id' => :contact_gifts,
    'Gift/:id' => :gift
  }.each do |end_point, json|
    get "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  # POST requests
  {
    'Contact/Transaction' => :import,
    'Contact' => :contact,
    'ContactIndividual' => :individual,
    'v2/Gift/Transaction' => :import,
    'v2/Gift/Transactions' => :import,
    'Gift' => :gift,
    'Gift/Bulk' => :gifts
  }.each do |end_point, json|
    post "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  # PUT requests
  {
    'Contact/:id' => :contact,
    'ContactIndividual/:id' => :individual,
    'Gift/:id' => :gift
  }.each do |end_point, json|
    put "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  # DELETE requests
  [
    'ContactIndividual/:id',
    'Gift/:id'
  ].each do |end_point|
    delete "/api/#{end_point}" do
      content_type :json
      status 204
    end
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    FixturesHelper.read(file_name)
  end
end
