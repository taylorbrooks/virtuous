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

  describe '#get_contact(id)' do
    it 'returns a hash' do
      expect(client.get_contact(1)).to be_a(Hash)
    end

    it 'queries contacts' do
      expect(client).to receive(:get).with('api/Contact/1').and_call_original

      resource = client.get_contact(1)

      expect(resource[:id]).to eq(1)
    end
  end

  describe '#import_contact(data)' do
    subject(:resource) do
      client.import_contact(
        reference_source: 'Test source',
        reference_id: 123,
        contact_type: 'Organization',
        name: 'Test Org',
        title: 'Mr',
        first_name: 'Test',
        last_name: 'Individual',
        email: 'test_individual@email.com'
      )
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/Contact/Transaction',
          {
            'referenceSource' => 'Test source',
            'referenceId' => 123,
            'contactType' => 'Organization',
            'name' => 'Test Org',
            'title' => 'Mr',
            'firstName' => 'Test',
            'lastName' => 'Individual',
            'email' => 'test_individual@email.com'
          }
        )
        .and_call_original
      resource
    end
  end

  describe '#create_contact(data)' do
    subject(:resource) do
      client.create_contact(
        reference_source: 'Test source',
        reference_id: 123,
        contact_type: 'Organization',
        name: 'Test Org',
        contact_individuals: [{
          first_name: 'Test',
          last_name: 'Individual'
        }]
      )
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/Contact',
          {
            'referenceSource' => 'Test source',
            'referenceId' => 123,
            'contactType' => 'Organization',
            'name' => 'Test Org',
            'contactIndividuals' => [{
              'firstName' => 'Test',
              'lastName' => 'Individual'
            }]
          }
        )
        .and_call_original
      resource
    end

    it 'returns a hash' do
      expect(resource).to be_a(Hash)
    end
  end

  describe '#update_contact(id, data)' do
    subject(:resource) do
      client.update_contact(
        1,
        reference_source: 'Test source',
        reference_id: 123,
        contact_type: 'Organization',
        name: 'Test Org'
      )
    end

    it 'passes options' do
      expect(client).to receive(:put)
        .with(
          'api/Contact/1',
          {
            'referenceSource' => 'Test source',
            'referenceId' => 123,
            'contactType' => 'Organization',
            'name' => 'Test Org'
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
