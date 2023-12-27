require 'spec_helper'

RSpec.describe Virtuous::Client::ContactAddress, type: :model do
  include_context 'resource specs'

  describe '#get_contact_addresses(contact_id)' do
    subject(:resource) { client.get_contact_addresses(1) }

    it 'returns a list of addresses' do
      expect(subject).to be_a(Array)
    end

    it 'passes options' do
      expect(client).to receive(:get)
        .with('api/ContactAddress/ByContact/1')
        .and_call_original
      resource
    end
  end

  describe '#create_contact_address(data)' do
    subject(:resource) do
      client.create_contact_address(
        contact_id: 1, label: 'Home address', address1: '324 Frank Island',
        address2: 'Apt. 366', city: 'Antonioborough', state: 'Massachusetts', postal: '27516',
        country: 'USA'
      )
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/ContactAddress',
          {
            'contactId' => 1, 'label' => 'Home address', 'address1' => '324 Frank Island',
            'address2' => 'Apt. 366', 'city' => 'Antonioborough', 'state' => 'Massachusetts',
            'postal' => '27516', 'country' => 'USA'
          }
        )
        .and_call_original
      resource
    end

    it 'returns a hash' do
      expect(resource).to be_a(Hash)
    end
  end

  describe '#update_contact_address(id, data)' do
    subject(:resource) do
      client.update_contact_address(
        1, label: 'Home address', address1: '324 Frank Island', address2: 'Apt. 366',
           city: 'Antonioborough', state: 'Massachusetts', postal: '27516', country: 'USA'
      )
    end

    it 'passes options' do
      expect(client).to receive(:put)
        .with(
          'api/ContactAddress/1',
          {
            'label' => 'Home address', 'address1' => '324 Frank Island', 'address2' => 'Apt. 366',
            'city' => 'Antonioborough', 'state' => 'Massachusetts', 'postal' => '27516',
            'country' => 'USA'
          }
        )
        .and_call_original
      resource
    end

    it 'returns a hash' do
      expect(resource).to be_a(Hash)
    end
  end
end
