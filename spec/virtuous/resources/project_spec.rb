require 'spec_helper'

RSpec.describe Virtuous::Client::Individual, type: :model do
  include_context 'resource specs'

  describe '#project_query_options' do
    it 'returns a hash' do
      expect(client.project_query_options).to be_a(Hash)
    end

    it 'queries options' do
      expect(client).to receive(:get).with('api/Project/QueryOptions').and_call_original

      response = client.project_query_options

      expect(response).to have_key(:options)
    end
  end

  describe '#query_projects(**options)' do
    it 'returns a list of projects' do
      response = client.query_projects
      expect(response).to be_a(Hash)

      expect(response).to have_key(:list)
      expect(response).to have_key(:total)
    end

    it 'sends take as a query param' do
      expect(client).to receive(:post).with(URI('api/Project/Query?take=12'),
                                            {}).and_call_original

      client.query_projects(take: 12)
    end

    it 'sends skip as a query param' do
      expect(client).to receive(:post).with(URI('api/Project/Query?skip=12'),
                                            {}).and_call_original

      client.query_projects(skip: 12)
    end

    it 'sends sort_by in the body' do
      expect(client).to receive(:post).with(URI('api/Project/Query'), { 'sortBy' => 'Id' })
                                      .and_call_original

      client.query_projects(sort_by: 'Id')
    end

    it 'sends descending in the body' do
      expect(client).to receive(:post).with(
        URI('api/Project/Query'), { 'descending' => true }
      ).and_call_original

      client.query_projects(descending: true)
    end

    it 'sends conditions in the body' do
      expect(client).to receive(:post).with(
        URI('api/Project/Query'), { 'groups' => [{ 'conditions' => [{
          'parameter' => 'Project Code', 'operator' => 'Is', 'value' => 102
        }] }] }
      ).and_call_original

      client.query_projects(conditions: [{
                              parameter: 'Project Code', operator: 'Is', value: 102
                            }])
    end
  end
end
