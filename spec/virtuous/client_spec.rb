require 'spec_helper'

RSpec.describe Virtuous::Client do
  let(:attrs) { { api_key: 'test_api_key' } }
  let(:attrs_without_authentication) { { api_key: nil } }

  subject(:client) { described_class.new(**attrs) }

  shared_examples 'param request' do |verb|
    let(:endpoint) { "#{verb}_test" }
    let(:url) { "https://api.virtuoussoftware.com/#{endpoint}" }

    before do
      stub_request(:any, /_test/).to_return(body: response_body.to_json)
    end

    it 'requests at `path` argument' do
      client.public_send(verb, endpoint)

      expect(WebMock).to have_requested(verb, url)
    end

    it 'passes request parameters' do
      client.public_send(verb, endpoint, request_params)

      expect(WebMock).to have_requested(verb, url).with(query: request_params)
    end

    it 'returns parsed response body' do
      expect(client.public_send(verb, endpoint)).to eq(response_body)
    end
  end

  shared_examples 'body request' do |verb|
    let(:body) { { 'test' => 123 } }
    let(:endpoint) { "#{verb}_test" }
    let(:url) { "https://api.virtuoussoftware.com/#{endpoint}" }

    let(:do_request) { client.public_send(verb, endpoint, body) }

    before do
      stub_request(:any, /_test/).to_return(body: body.to_json)
    end

    it 'requests at `path` argument' do
      do_request

      expect(WebMock).to have_requested(verb, url)
    end

    it 'passes request body' do
      do_request

      expect(WebMock)
        .to have_requested(verb, url)
        .with(body: body)
    end

    it 'returns parsed response body' do
      expect(do_request).to eq(body)
    end
  end

  shared_examples 'api key auth' do
    let(:path) { '/api/Contact/1' }
    let(:url) { "https://api.virtuoussoftware.com#{path}" }

    it 'doesn\'t request an access token' do
      client.get(path)

      expect(WebMock).not_to have_requested(:post, 'https://api.virtuoussoftware.com/Token')
    end

    it 'uses the key in requests' do
      client.get(path)

      expect(WebMock).to have_requested(:get, url)
        .with(headers: { 'Authorization' => "Bearer #{api_key}" })
    end
  end

  shared_examples 'valid access token auth' do
    let(:path) { '/api/Contact/1' }
    let(:url) { "https://api.virtuoussoftware.com#{path}" }

    it 'doesn\'t request an access token' do
      client.get(path)

      expect(WebMock).not_to have_requested(:post, 'https://api.virtuoussoftware.com/Token')
    end

    it 'uses the access token in requests' do
      client.get(path)

      expect(WebMock).to have_requested(:get, url)
        .with(headers: { 'Authorization' => "Bearer #{access_token}" })
    end
  end

  shared_examples 'expired access token auth' do
    let(:path) { '/api/Contact/1' }
    let(:url) { "https://api.virtuoussoftware.com#{path}" }

    it 'doesn\'t request an access token before doing a request' do
      client

      expect(WebMock).not_to have_requested(:post, 'https://api.virtuoussoftware.com/Token')
    end

    it 'requests a new access token before doing a request' do
      client.get(path)

      body = URI.encode_www_form({ grant_type: 'refresh_token', refresh_token: refresh_token })

      expect(WebMock).to have_requested(:post, 'https://api.virtuoussoftware.com/Token')
        .with(body: body)

      expect(client.refresh_token).to eq('new_refresh_token')
      expect(client.access_token).to eq('new_access_token')
      expect(client.expires_at).to be > Time.now
    end

    it 'doesn\'t request an access token a second time' do
      client.get(path)

      WebMock.reset_executed_requests!

      client.get(path)

      expect(WebMock).not_to have_requested(:post, 'https://api.virtuoussoftware.com/Token')
    end

    it 'uses the new access token in requests' do
      client.get(path)

      expect(WebMock).to have_requested(:get, url)
        .with(headers: { 'Authorization' => 'Bearer new_access_token' })
    end
  end

  context 'with api key' do
    let(:api_key) { 'test_api_key' }
    let(:attrs) { { api_key: api_key } }

    it_behaves_like 'api key auth'
  end

  context 'with access token' do
    let(:access_token) { 'test_access_token' }
    let(:attrs) { { access_token: access_token } }

    it_behaves_like 'valid access token auth'
  end

  context 'with non expired access token' do
    let(:access_token) { 'test_access_token' }
    let(:refresh_token) { 'test_refresh_token' }
    let(:attrs) do
      { access_token: access_token, refresh_token: refresh_token, expires_at: Time.now + 1_295_999 }
    end

    it_behaves_like 'valid access token auth'
  end

  context 'with expired access token' do
    let(:access_token) { 'test_access_token' }
    let(:refresh_token) { 'test_refresh_token' }
    let(:attrs) do
      {
        access_token: access_token, refresh_token: refresh_token, expires_at: Time.new(2023, 12, 11)
      }
    end

    it_behaves_like 'expired access token auth'
  end

  context 'with no access token' do
    let(:refresh_token) { 'test_refresh_token' }
    let(:attrs) { { refresh_token: refresh_token } }

    it_behaves_like 'expired access token auth'
  end

  context 'with password auth' do
    let(:attrs) { {} }
    let(:access_token) { 'new_access_token' }

    before :each do
      client.authenticate('user@email.com', 'password')
      WebMock.reset_executed_requests!
    end

    it_behaves_like 'valid access token auth'
  end

  describe '#authenticate(email, password, otp = nil)' do
    let(:email) { 'user@email.com' }
    let(:password) { 'test_password' }
    let(:attrs) { {} }

    it 'sends a request to retrieve a token' do
      client.authenticate(email, password)

      body = URI.encode_www_form({ grant_type: 'password', username: email, password: password })

      expect(WebMock).to have_requested(:post, 'https://api.virtuoussoftware.com/Token')
        .with(body: body)
    end

    it 'sets the new token' do
      client.authenticate(email, password)

      expect(client.refresh_token).to eq('new_refresh_token')
      expect(client.access_token).to eq('new_access_token')
      expect(client.expires_at).to be > Time.now
    end

    it 'returns the new token values' do
      response = client.authenticate(email, password)

      expect(response[:refresh_token]).to eq(client.refresh_token)
      expect(response[:access_token]).to eq(client.access_token)
      expect(response[:expires_at]).to eq(client.expires_at)
    end

    context 'with otp' do
      let(:email) { 'otp@user.com' }

      it 'returns requires_otp if otp is not set' do
        response = client.authenticate(email, password)

        expect(response[:requires_otp]).to eq(true)
      end

      it 'sets the new token' do
        client.authenticate(email, password, '111111')

        expect(client.refresh_token).to eq('new_refresh_token')
        expect(client.access_token).to eq('new_access_token')
        expect(client.expires_at).to be > Time.now
      end
    end
  end

  describe '#get(path, options = {})' do
    let(:request_params) { { 'test' => 123 } }
    let(:response_body) { request_params }

    include_examples 'param request', :get
  end

  describe '#delete(path, options = {})' do
    let(:request_params) { { 'test' => 123 } }
    let(:response_body) { {} }

    include_examples 'param request', :delete
  end

  describe '#patch(path, options = {})' do
    include_examples 'body request', :patch
  end

  describe '#post(path, options = {})' do
    include_examples 'body request', :post
  end

  describe '#put(path, options = {})' do
    include_examples 'body request', :put
  end
end
