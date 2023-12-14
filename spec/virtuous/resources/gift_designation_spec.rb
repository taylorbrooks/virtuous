require 'spec_helper'

RSpec.describe Virtuous::Client::Individual, type: :model do
  include_context 'resource specs'

  describe '#gift_designation_query_options' do
    it 'returns a hash' do
      expect(client.gift_designation_query_options).to be_a(Hash)
    end

    it 'queries options' do
      expect(client).to receive(:get).with('api/GiftDesignation/QueryOptions').and_call_original

      response = client.gift_designation_query_options

      expect(response).to have_key(:options)
    end
  end

  describe '#query_gift_designations(**options)' do
    it 'returns a list of designations' do
      response = client.query_gift_designations
      expect(response).to be_a(Hash)

      expect(response).to have_key(:list)
      expect(response).to have_key(:total)
    end

    it 'sends take as a query param' do
      expect(client).to receive(:post).with(URI('api/GiftDesignation/Query?take=12'),
                                            {}).and_call_original

      client.query_gift_designations(take: 12)
    end

    it 'sends skip as a query param' do
      expect(client).to receive(:post).with(URI('api/GiftDesignation/Query?skip=12'),
                                            {}).and_call_original

      client.query_gift_designations(skip: 12)
    end

    it 'sends sort_by in the body' do
      expect(client).to receive(:post).with(URI('api/GiftDesignation/Query'), { 'sortBy' => 'Id' })
                                      .and_call_original

      client.query_gift_designations(sort_by: 'Id')
    end

    it 'sends descending in the body' do
      expect(client).to receive(:post).with(
        URI('api/GiftDesignation/Query'), { 'descending' => true }
      ).and_call_original

      client.query_gift_designations(descending: true)
    end

    it 'sends conditions in the body' do
      expect(client).to receive(:post).with(
        URI('api/GiftDesignation/Query'), { 'groups' => [{ 'conditions' => [{
          'parameter' => 'Gift Id', 'operator' => 'Is', 'value' => 102
        }] }] }
      ).and_call_original

      client.query_gift_designations(conditions: [{
                                       parameter: 'Gift Id', operator: 'Is', value: 102
                                     }])
    end
  end
end
