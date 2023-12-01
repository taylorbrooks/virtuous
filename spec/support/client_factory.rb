RSpec.shared_context 'resource specs' do
  let(:attrs) do
    {
      api_key: 'test_api_key',
      base_url: 'http://api.virtuoussoftware.com'
    }
  end

  let(:client) { Virtuous::Client.new(**attrs) }
end
