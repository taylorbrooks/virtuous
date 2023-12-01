require 'spec_helper'

RSpec.describe Virtuous::Client do
  let(:attrs) { { api_key: 'test_pi_key' } }
  let(:attrs_without_authentication) { { api_key: nil } }

  subject(:client) { described_class.new(**attrs) }

  describe '#initialize' do
    it 'requries `api_key` param' do
      expect { described_class.new(**attrs_without_authentication) }
        .to raise_error(ArgumentError, /api_key/)
    end
  end

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
