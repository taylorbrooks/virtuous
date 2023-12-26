require 'spec_helper'

RSpec.describe Virtuous::Client::RecurringGift, type: :model do
  include_context 'resource specs'

  describe '#get_recurring_gift(id)' do
    it 'returns a hash' do
      expect(client.get_recurring_gift(1)).to be_a(Hash)
    end

    it 'queries gifts' do
      expect(client).to receive(:get).with('api/RecurringGift/1').and_call_original

      resource = client.get_recurring_gift(1)

      expect(resource[:id]).to eq(1)
    end
  end

  describe '#create_recurring_gift(data)' do
    subject(:resource) do
      client.create_recurring_gift(
        contact_id: 1, start_date: Date.today, frequency: 'Monthly', amount: 1000
      )
    end

    it 'passes options' do
      expect(client).to receive(:post)
        .with(
          'api/RecurringGift',
          {
            'contactId' => 1, 'startDate' => Date.today, 'frequency' => 'Monthly', 'amount' => 1000
          }
        )
        .and_call_original
      resource
    end

    it 'returns a hash' do
      expect(resource).to be_a(Hash)
    end
  end

  describe '#update_recurring_gift(id, data)' do
    subject(:resource) do
      client.update_recurring_gift(
        1, start_date: Date.today, frequency: 'Daily', amount: 500
      )
    end

    it 'passes options' do
      expect(client).to receive(:put)
        .with(
          'api/RecurringGift/1',
          {
            'startDate' => Date.today, 'frequency' => 'Daily', 'amount' => 500
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
