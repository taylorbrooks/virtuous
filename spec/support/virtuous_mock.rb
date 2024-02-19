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
    'ContactAddress/ByContact/:id' => :contact_addresses,
    'Gift/:id' => :gift,
    'RecurringGift/:id' => :recurring_gift,
    'Gift/:transaction_source/:transaction_id' => :gift,
    'GiftDesignation/QueryOptions' => :gift_designation_query_options,
    'Project/QueryOptions' => :project_query_options # TODO: change fixture
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
    'RecurringGift' => :recurring_gift,
    'Gift/Bulk' => :gifts,
    'GiftDesignation/Query' => :gift_designations,
    'Project/Query' => :projects, # TODO: change fixture
    'ContactAddress' => :contact_address
  }.each do |end_point, json|
    post "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  # PUT requests
  {
    'Contact/:id' => :contact,
    'ContactIndividual/:id' => :individual,
    'Gift/:id' => :gift,
    'RecurringGift/:id' => :recurring_gift,
    'ContactAddress/:id' => :contact_address
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

  # Auth request

  post '/Token' do
    content_type :json

    body = URI.decode_www_form(request.body.read).to_h

    if body['username'] == 'otp@user.com' && body['otp'].nil?
      status 202
      return {
        error: 'awaiting_verification',
        error_description: '2-step verification code (OTP) sent.'
      }.to_json
    end

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
