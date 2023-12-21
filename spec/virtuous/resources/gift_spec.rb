require 'spec_helper'

RSpec.describe Virtuous::Client::Gift, type: :model do
  include_context 'resource specs'

  describe '#get_contact_gifts(contact_id, **options)' do
    subject(:resource) do
      client.get_contact_gifts(
        1,
        sort_by: 'GiftDate',
        skip: 10,
        take: 10
      )
    end

    it 'returns a list of gifts' do
      expect(subject[:list]).to be_a(Array)
    end

    it 'passes options' do
      expect(client).to receive(:get)
        .with(
          'api/Gift/ByContact/1',
          {
            'sortBy' => 'GiftDate',
            'skip' => 10,
            'take' => 10
          }
        )
        .and_call_original
      resource
    end
  end

  describe '#get_gift(id)' do
    it 'returns a hash' do
      expect(client.get_gift(1)).to be_a(Hash)
    end

    it 'queries gifts' do
      expect(client).to receive(:get).with('api/Gift/1').and_call_original

      resource = client.get_gift(1)

      expect(resource[:id]).to eq(1)
    end
  end

  describe '#find_gift_by_transaction_id(id)' do
    let(:transaction_source) { 'source' }
    let(:transaction_id) { 42 }

    it 'returns a hash' do
      expect(client.find_gift_by_transaction_id(transaction_source, transaction_id)).to be_a(Hash)
    end

    it 'queries gifts' do
      expect(client).to receive(:get).with("api/Gift/#{transaction_source}/#{transaction_id}")
                                     .and_call_original

      resource = client.find_gift_by_transaction_id(transaction_source, transaction_id)

      expect(resource[:transaction_source]).to eq(transaction_source)
      expect(resource[:transaction_id]).to eq(transaction_id)
    end
  end

  describe '#import_gift(data)' do
    subject(:resource) do
      client.import_gift(
        gift_type: 'Cash', amount: 10.5, currency_code: 'USD', gift_date: Date.today,
        contact: {
          contact_type: 'Organization', name: 'Org name', first_name: 'John',
          last_name: 'Doe', email: 'john_doe@email.com'
        }
      )
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/v2/Gift/Transaction',
          {
            'giftType' => 'Cash', 'amount' => 10.5, 'currencyCode' => 'USD',
            'giftDate' => Date.today, 'contact' => {
              'contactType' => 'Organization', 'name' => 'Org name', 'firstName' => 'John',
              'lastName' => 'Doe', 'email' => 'john_doe@email.com'
            }
          }
        )
        .and_call_original
      resource
    end
  end

  describe '#import_gifts(data)' do
    subject(:resource) do
      client.import_gifts(
        transaction_source: 'Source', transactions: [
          {
            gift_type: 'Cash', amount: 10.5, currency_code: 'USD', gift_date: Date.today,
            contact: {
              contact_type: 'Organization', name: 'Org name', first_name: 'John',
              last_name: 'Doe', email: 'john_doe@email.com'
            }
          },
          {
            gift_type: 'Cash', amount: 5.0, currency_code: 'USD', gift_date: Date.today,
            contact: {
              contact_type: 'Organization', name: 'Org name', first_name: 'John',
              last_name: 'Doe', email: 'john_doe@email.com'
            }
          }
        ]
      )
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/v2/Gift/Transactions',
          {
            'transactionSource' => 'Source', 'transactions' => [
              {
                'giftType' => 'Cash', 'amount' => 10.5, 'currencyCode' => 'USD',
                'giftDate' => Date.today, 'contact' => {
                  'contactType' => 'Organization', 'name' => 'Org name', 'firstName' => 'John',
                  'lastName' => 'Doe', 'email' => 'john_doe@email.com'
                }
              },
              {
                'giftType' => 'Cash', 'amount' => 5.0, 'currencyCode' => 'USD',
                'giftDate' => Date.today, 'contact' => {
                  'contactType' => 'Organization', 'name' => 'Org name', 'firstName' => 'John',
                  'lastName' => 'Doe', 'email' => 'john_doe@email.com'
                }
              }
            ]

          }
        )
        .and_call_original
      resource
    end
  end

  describe '#create_gift(data)' do
    subject(:resource) do
      client.create_gift(
        contact_id: 1, gift_type: 'Cash', amount: 10.5, currency_code: 'USD',
        gift_date: Date.today
      )
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/Gift',
          {
            'contactId' => 1, 'giftType' => 'Cash', 'amount' => 10.5, 'currencyCode' => 'USD',
            'giftDate' => Date.today
          }
        )
        .and_call_original
      resource
    end

    it 'returns a hash' do
      expect(resource).to be_a(Hash)
    end
  end

  describe '#create_gifts(data)' do
    subject(:resource) do
      client.create_gifts(
        [
          {
            contact_id: 1, gift_type: 'Cash', amount: 10.5, currency_code: 'USD',
            gift_date: Date.today
          },
          {
            contact_id: 2, gift_type: 'Cash', amount: 5.0, currency_code: 'USD',
            gift_date: Date.today
          }
        ]
      )
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/Gift/Bulk',
          [
            {
              'contactId' => 1, 'giftType' => 'Cash', 'amount' => 10.5, 'currencyCode' => 'USD',
              'giftDate' => Date.today
            },
            {
              'contactId' => 2, 'giftType' => 'Cash', 'amount' => 5.0, 'currencyCode' => 'USD',
              'giftDate' => Date.today
            }
          ]
        )
        .and_call_original
      resource
    end

    it 'returns a array' do
      expect(resource).to be_a(Array)
    end
  end

  describe '#update_gift(id, data)' do
    subject(:resource) do
      client.update_gift(
        1, gift_type: 'Cash', amount: 5.0, currency_code: 'USD',
           gift_date: Date.today
      )
    end

    it 'passes options' do
      expect(client).to receive(:put)
        .with(
          'api/Gift/1',
          {
            'giftType' => 'Cash', 'amount' => 5.0, 'currencyCode' => 'USD',
            'giftDate' => Date.today
          }
        )
        .and_call_original
      resource
    end

    it 'returns a hash' do
      expect(resource).to be_a(Hash)
    end
  end

  describe '#delete_gift(id)' do
    subject(:resource) { client.delete_gift(1) }

    it 'calls delete on the gift' do
      expect(client).to receive(:delete)
        .with('api/Gift/1')
        .and_call_original
      resource
    end
  end
end
