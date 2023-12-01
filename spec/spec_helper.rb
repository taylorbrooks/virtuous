$LOAD_PATH.unshift(File.join(__FILE__, '..', '..', 'lib'))

SPEC_DIR = File.dirname(__FILE__)
FIXTURES_DIR = File.join(SPEC_DIR, 'support', 'fixtures')

require 'virtuous'
require 'webmock/rspec'
require_relative 'support/fixtures_helper'
require_relative 'support/virtuous_mock'
require_relative 'support/client_factory'

RSpec.configure do |config|
  config.before :suite do
    WebMock.disable_net_connect!
  end

  config.before :each do
    stub_request(:any, /virtuoussoftware/).to_rack(VirtuousMock)
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
