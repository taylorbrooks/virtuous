require 'spec_helper'
require 'rack/utils'

CODES = Rack::Utils::HTTP_STATUS_CODES.keys.freeze

RSpec.describe Virtuous::Error do
  let(:client) do
    Virtuous::Client.new(
      base_url: 'http://some-virtuous-uri.com',
      api_key: 'test_api_key'
    )
  end

  def stub(code, body)
    stub_request(:any, /virtuous/).to_return(status: code, body: body)
  end

  def expect_failure(code, body)
    url = 'http://some-virtuous-uri.com/anything'

    expect do
      client.get('anything')
    end.to raise_error(Virtuous::Error, /#{code}: #{url} #{body}/)
  end

  def expect_success
    expect { client.get('anything') }.to_not raise_error
  end

  context 'informational responses' do
    CODES.grep(100..199).each do |code|
      it "does not raise error for #{code}" do
        stub(code, '{}')
        expect_success
      end
    end
  end

  context 'success responses' do
    CODES.grep(200..299).each do |code|
      it "does not raise error for #{code}" do
        stub(code, '{}')
        expect_success
      end
    end
  end

  context 'redirection responses' do
    CODES.grep(300..399).each do |code|
      it "does not raise error for #{code}" do
        stub(code, '')
        expect_success
      end
    end
  end

  context 'client error responses' do
    CODES.grep(400..499).each do |code|
      it "raises exception for #{code}" do
        stub(code, 'test client error')
        expect_failure(code, 'test client error')
      end
    end
  end

  context 'server error responses' do
    CODES.grep(500..599).each do |code|
      it "raises exception for #{code}" do
        stub(code, 'test client error')
        expect_failure(code, 'test client error')
      end
    end
  end
end
