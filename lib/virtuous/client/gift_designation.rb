module Virtuous
  class Client
    module GiftDesignation
      ##
      # Returns a list of available gift designation query options.
      def gift_designation_query_options
        parse(get('api/GiftDesignation/QueryOptions'))
      end

      ##
      # Queries gift designations.
      #
      #      client.query_gift_designations(
      #        take: 5, skip: 0, sort_by: 'Id',
      #        conditions: [{ parameter: 'Gift Id', operator: 'Is', value: 102 }]
      #      )
      #
      # ### Options
      #
      # - `:take`: The maximum amount of designations to query. Default: 10. Max is 1000.
      # - `:skip`: The number of designations to skip. Default: 0.
      # - `:sort_by`: The value to sort records by.
      # You can sort by Id, Amount, GiftDate, ReceiptDate and Batch.
      # - `:descending`: If true the records will be sorted in descending order.
      # - `:conditions`: An array of conditions to filter the gift designation.
      # Use #gift_designation_query_options to see
      # a full list of available conditions.
      #
      # ### Returns
      # A hash with a list and the total amount of gift designations that satisfy the conditions.
      #
      #     { list: [...], total: n }
      #
      def query_gift_designations(**options)
        uri = URI('api/GiftDesignation/Query')
        query_params = options.slice(:take, :skip)
        uri.query = URI.encode_www_form(query_params) unless query_params.empty?

        parse(post(uri, format(query_gift_designations_body(options))))
      end

      private

      def query_gift_designations_body(options)
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
