module Virtuous
  class Client
    ##
    # ### Recurring Gift data
    #
    #     {
    #       contactId: [Integer],
    #       startDate: [Time],
    #       frequency: [String],
    #       amount: [Float],
    #       nextExpectedPaymentDate: [Time],
    #       anticipatedEndDate: [Time],
    #       thankYouDate: [Time],
    #       segmentId: [Integer],
    #       automatedPayments: [Boolean],
    #       trackPayments: [Boolean],
    #       isPrivate: [Boolean],
    #       designations: [
    #         {
    #           projectId: [Integer],
    #           amountDesignated: [Float]
    #         }
    #       ],
    #       customFields: [
    #         {
    #           name: [String],
    #           value: [String],
    #           displayName: [String]
    #         }
    #       ]
    #     }
    #
    module RecurringGift
      ##
      # Fetches a recurring gift record by id.
      #
      # @example
      #     client.get_recurring_gift(1)
      #
      # @param id [Integer] The id of the recurring gift.
      #
      # @return [Hash] The recurring gift information in a hash.
      def get_recurring_gift(id)
        parse(get("api/RecurringGift/#{id}"))
      end

      ##
      # Creates a recurring gift.
      #
      # @example
      #     client.create_recurring_gift(
      #       contact_id: 1, start_date: Date.today, frequency: 'Monthly', amount: 1000
      #     )
      #
      # @param data [Hash] A hash containing the recurring gift details.
      #   Refer to the [Recurring Gift data](#label-Recurring+Gift+data)
      #   section above to see the available attributes.
      #
      # @return [Hash] The recurring gift that has been created.
      def create_recurring_gift(data)
        parse(post('api/RecurringGift', format(data)))
      end

      ##
      # Updates a recurring gift.
      #
      # @example
      #     client.update_recurring_gift(
      #       1, start_date: Date.today, frequency: 'Daily', amount: 500
      #     )
      #
      # @note Excluding a property will remove it's value from the object.
      # If you're only updating a single property, the entire model is still required.
      #
      # @param id [Integer] The id of the recurring gift to update.
      # @param data [Hash] A hash containing the recurring gift details.
      #   Refer to the [Gift data](#label-Recurring+Gift+data) section
      #   above to see the available attributes.
      #
      # @return [Hash] The recurring gift that has been updated.
      def update_recurring_gift(id, data)
        parse(put("api/RecurringGift/#{id}", format(data)))
      end
    end
  end
end
