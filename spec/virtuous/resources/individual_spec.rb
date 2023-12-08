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

  describe '#get_individual(id)' do
    it 'returns a hash' do
      expect(client.get_individual(2)).to be_a(Hash)
    end

    it 'queries individuals' do
      expect(client).to receive(:get).with('api/ContactIndividual/2').and_call_original

      resource = client.get_individual(2)

      expect(resource[:id]).to eq(2)
    end
  end

  describe '#create_individual(data)' do
    subject(:resource) do
      client.create_individual(first_name: 'John', last_name: 'Doe', contact_id: 1)
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/ContactIndividual',
          {
            'firstName' => 'John',
            'lastName' => 'Doe',
            'contactId' => 1
          }
        )
        .and_call_original
      resource
    end

    it 'returns a hash' do
      expect(resource).to be_a(Hash)
    end
  end

  describe '#update_individual(id, data)' do
    subject(:resource) do
      client.update_individual(
        2,
        first_name: 'John', last_name: 'Doe'
      )
    end

    it 'passes options' do
      expect(client).to receive(:put)
        .with(
          'api/ContactIndividual/2',
          {
            'firstName' => 'John',
            'lastName' => 'Doe'
          }
        )
        .and_call_original
      resource
    end

    it 'returns a hash' do
      expect(resource).to be_a(Hash)
    end
  end

  describe '#delete_individual(id)' do
    subject(:resource) { client.delete_individual(2) }

    it 'calls delete on the individual' do
      expect(client).to receive(:delete)
        .with('api/ContactIndividual/2')
        .and_call_original
      resource
    end
  end
end
