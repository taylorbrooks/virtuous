require 'spec_helper'

RSpec.describe Virtuous::Client::Individual, type: :model do
  include_context 'resource specs'

  describe '#find_individual_by_email(email)' do
    it 'returns a hash' do
      expect(client.find_individual_by_email('email@test.com')).to be_a(Hash)
    end

    it 'queries individuals' do
      expect(client).to receive(:get).with('api/ContactIndividual/Find',
                                           { email: 'email@test.com' }).and_call_original

      resource = client.find_individual_by_email('email@test.com')

      expect(resource[:id]).to eq(2)
    end
  end
end
