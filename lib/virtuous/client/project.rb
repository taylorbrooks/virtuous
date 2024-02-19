module Virtuous
  class Client
    module Project
      ##
      # Queries a list of available project query options.
      # @return [Hash] A list of available project query options.
      def project_query_options
        parse(get('api/Project/QueryOptions'))
      end

      ##
      # Queries projects.
      #
      # @example
      #      client.query_projects(
      #        take: 5, skip: 0, sort_by: 'Id',
      #        conditions: [{ parameter: 'Project Code', operator: 'Is', value: 102 }]
      #      )
      #
      # @option options [Integer] :take The maximum amount of projects to query. Default: 10.
      #   Max is 1000.
      # @option options [Integer] :skip The number of projects to skip. Default: 0.
      # @option options [String] :sort_by The value to sort records by.
      # @option options [Boolean] :descending If true the records will be sorted in descending
      #   order.
      # @option options [Array] :conditions An array of conditions to filter the project.
      #   Use {project_query_options} to see
      #   a full list of available conditions.
      #
      # @return [Hash] A hash with a list and the total amount of projects that satisfy
      #   the conditions.
      # @example Output
      #     { list: [...], total: n }
      #
      def query_projects(**options)
        uri = URI('api/Project/Query')
        query_params = options.slice(:take, :skip)
        uri.query = URI.encode_www_form(query_params) unless query_params.empty?

        parse(post(uri, format(query_projects_body(options))))
      end

      private

      def query_projects_body(options)
        conditions = options[:conditions]
        body = options.slice(:sort_by, :descending)
        return body if conditions.nil?

        body.merge({
                     groups: [{
                       conditions: conditions
                     }]
                   })
      end
    end
  end
end
