require 'sinatra/base'
require 'securerandom'
require_relative 'fixtures_helper'

class VirtuousMock < Sinatra::Base
  # GET requests
  {
    'Contact/Find' => :contact,
    'Contact/:id' => :contact,
    'ContactIndividual/Find' => :individual,
    'ContactIndividual/:id' => :individual
  }.each do |end_point, json|
    get "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  # POST requests
  {
    'Contact/Transaction' => :import,
    'Contact' => :contact,
    'ContactIndividual' => :individual
  }.each do |end_point, json|
    post "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  # PUT requests
  {
    'Contact/:id' => :contact,
    'ContactIndividual/:id' => :individual
  }.each do |end_point, json|
    put "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  # DELETE requests
  [
    'ContactIndividual/:id'
  ].each do |end_point|
    delete "/api/#{end_point}" do
      content_type :json
      status 204
    end
  end

  # Auth request

  post '/Token' do
    content_type :json
    status 200
    {
      access_token: 'new_access_token',
      token_type: 'bearer',
      expires_in: 1_295_999,
      refresh_token: 'new_refresh_token',
      userName: 'user@email.com',
      twoFactorEnabled: 'False',
      '.issued': Time.now.gmtime,
      '.expires': (Time.now + 1_295_999).gmtime
    }.to_json
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    FixturesHelper.read(file_name)
  end
end
