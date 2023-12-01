require 'spec_helper'

RSpec.describe Virtuous::Client::Contact, type: :model do
  include_context 'resource specs'

  describe '#find_contact_by_email(email)' do
    it 'returns a hash' do
      expect(client.find_contact_by_email('email@test.com')).to be_a(Hash)
    end

    it 'queries contacts' do
      expect(client).to receive(:get).with('api/Contact/Find',
                                           { email: 'email@test.com' }).and_call_original

      resource = client.find_contact_by_email('email@test.com')

      expect(resource[:id]).to eq(1)
    end
  end
end
