module Virtuous
  class Client
    ##
    # ### Gift data
    #
    #     {
    #       contact_id: [Integer],
    #       gift_type: [String],
    #       gift_date: [Time],
    #       amount: [Float],
    #       transaction_source: [String],
    #       transaction_id: [String],
    #       batch: [String],
    #       segment_id: [Integer],
    #       receipt_segment_id: [Integer],
    #       media_outlet_id: [Integer],
    #       notes: [String],
    #       is_private: [Boolean],
    #       receipt_date: [Time],
    #       contact_individual_id: [Integer],
    #       contact_passthrough_id: [Integer],
    #       cash_accounting_code: [String],
    #       state: [String],
    #       is_tax_deductible: [Boolean],
    #       gift_ask_id: [Integer],
    #       passthrough_gift_ask_id: [Integer],
    #       grant_id: [Integer],
    #       contact_membership_id: [Integer],
    #       currency_code: [String],
    #       exchange_rate: [Float],
    #       check_number: [String],
    #       credit_card_type: [String],
    #       cryptocoin_type: [String],
    #       transaction_hash: [String],
    #       coin_sold_for_cash: [Boolean],
    #       coin_amount: [Float],
    #       date_coin_was_sold: [Time],
    #       coin_sale_amount: [Float],
    #       ticker_symbol: [String],
    #       number_of_shares: [Float],
    #       ira_custodian: [String],
    #       stock_sold_for_cash: [Boolean],
    #       date_stock_was_sold: [Time],
    #       stock_sale_amount: [Float],
    #       non_cash_gift_type_id: [Integer],
    #       non_cash_gift_type: [String],
    #       description: [String],
    #       non_cash_sold_for_cash: [Boolean],
    #       date_non_cash_was_sold: [Time],
    #       non_cash_original_amount: [Float],
    #       non_cash_sale_amount: [Float],
    #       gift_designations: [
    #         {
    #           project_id: [Integer],
    #           amount: [Float],
    #           state: [String]
    #         }
    #       ],
    #       gift_premiums: [
    #         {
    #           premium_id: [Integer],
    #           quantity: [Integer],
    #           state: [String]
    #         }
    #       ],
    #       pledge_payments: [
    #         {
    #           id: [Integer],
    #           amount: [Float],
    #           state: [String]
    #         }
    #       ],
    #       recurring_gift_payments: [
    #         {
    #           id: [Integer],
    #           amount: [Float],
    #           state: [String]
    #         }
    #       ],
    #       tribute_type: [String],
    #       tribute_id: [Integer],
    #       tribute_description: [String],
    #       acknowledgee_id: [Integer],
    #       reversed_gift_id: [Integer],
    #       custom_fields: [
    #         {
    #           name: [String],
    #           value: [String],
    #           display_name: [String]
    #         }
    #       ]
    #     }
    #
    module Gift
      ##
      # Gets the gifts made by a contact.
      #
      # @example
      #     client.get_contact_gifts(1, take: 10)
      #
      # @param contact_id [Hash] The id of the Contact.
      # @option options [String] :sort_by The field to be sorted. Supported: `Id`, `GiftDate`,
      #   `Amount`, `Batch`, `CreatedDateTime`.
      # @option options [Boolean] :descending The direction to be sorted.
      # @option options [Integer] :skip The number of records to skip. Default = 0.
      # @option options [Integer] :take The number of records to take. Default = 10.
      #
      # @return [Hash] A hash with a list of gifts and the total amount of gifts belonging to the
      #   contact
      # @example Output
      #     { list: [...], total: n }
      #
      def get_contact_gifts(contact_id, **options)
        options = options.slice(:sort_by, :descending, :skip, :take)

        parse(get(
                "api/Gift/ByContact/#{contact_id}",
                format(options)
              ))
      end

      ##
      # Fetches a gift record by id.
      #
      # @example
      #     client.get_gift(1)
      #
      # @param id [Integer] The id of the gift.
      #
      # @return [Hash] The gift information in a hash.
      def get_gift(id)
        parse(get("api/Gift/#{id}"))
      end

      ##
      # Fetches a gift record by transaction id.
      #
      # @example
      #     client.find_gift_by_transaction_id('source', 1)
      #
      # @param transaction_source [String] The source of the transaction.
      # @param transaction_id [Integer, String] The id of the transaction.
      #
      # @return [Hash] The gift information in a hash.
      def find_gift_by_transaction_id(transaction_source, transaction_id)
        encoded_id = transaction_id.is_a?(String) ? encode(transaction_id) : transaction_id
        parse(get("api/Gift/#{encode(transaction_source)}/#{encoded_id}"))
      end

      ##
      # Creates a gift.
      #
      # @example
      #     client.create_gift(
      #       contact_id: 1, gift_type: 'Cash', amount: 10.5, currency_code: 'USD',
      #       gift_date: Date.today
      #     )
      #
      # @param data [Hash] A hash containing the gift details.
      #   Refer to the [Gift data](#label-Gift+data) section
      #   above to see the available attributes.
      #
      # @return [Hash] The gift that has been created.
      def create_gift(data)
        parse(post('api/Gift', format(data)))
      end

      ##
      # Creates gifts in bulks of up to 100 at a time.
      #
      # @example
      #     client.create_gifts([
      #       {
      #         contact_id: 1, gift_type: 'Cash', amount: 10.5, currency_code: 'USD',
      #         gift_date: Date.today
      #       },
      #       {
      #         contact_id: 2, gift_type: 'Cash', amount: 5.0, currency_code: 'USD',
      #         gift_date: Date.today
      #       }
      #     ])
      #
      # @param gifts [Array] An array of gifts.
      #   Refer to the [Gift data](#label-Gift+data) section
      #   above to see the available attributes.
      #
      # @return [Array] An array of gifts.
      def create_gifts(gifts)
        request_body = gifts.map { |gift| format(gift) }
        response = post('api/Gift/Bulk', request_body)
        response.map { |gift| parse(gift) }
      end

      ##
      # Updates a gift.
      #
      # @example
      #     client.update_gift(
      #       1, gift_type: 'Cash', amount: 5.0, currency_code: 'USD',
      #       gift_date: Date.today
      #     )
      #
      # @note Excluding a property will remove it's value from the object.
      # If you're only updating a single property, the entire model is still required.
      #
      # @param id [Integer] The id of the gift to update.
      # @param data [Hash] A hash containing the gift details.
      #   Refer to the [Gift data](#label-Gift+data) section
      #   above to see the available attributes.
      #
      # @return [Hash] The gift that has been updated.
      def update_gift(id, data)
        parse(put("api/Gift/#{id}", format(data)))
      end

      ##
      # Delete a gift.
      #
      # @example
      #     client.delete_gift(1)
      #
      # @param id [Integer] The id of the gift to delete.
      def delete_gift(id)
        delete("api/Gift/#{id}")
      end

      ##
      # Creates a gift. This ensures the gift is matched using the Virtuous matching algorithms
      # for Contacts, Recurring gifts, Designations, etc.
      #
      # Transactions are posted to the API and are set to a holding state.
      # At midnight, transactions are bundled into imports based on the source they were posted
      # with.
      # The organization reviews the imported transactions, and then clicks run.
      #
      # @example
      #     client.import_gift(
      #       gift_type: 'Cash', amount: 10.5, currency_code: 'USD', gift_date: Date.today,
      #       contact: {
      #         contact_type: 'Organization', name: 'Org name', first_name: 'John',
      #         last_name: 'Doe', email: 'john_doe@email.com'
      #       }
      #     )
      #
      # @param data [Hash] A hash containing the gift details.
      #
      # #### Full list of accepted fields
      #
      #     {
      #       transaction_source: [String],
      #       transaction_id: [String],
      #       contact: [Contact],
      #       gift_date: [String],
      #       cancel_date: [String],
      #       gift_type: [String],
      #       amount: [String],
      #       currency_code: [String],
      #       exchange_rate: [Float],
      #       frequency: [String],
      #       recurring_gift_transaction_id: [String],
      #       recurring_gift_transaction_update: [Boolean],
      #       pledge_frequency: [String],
      #       pledge_transaction_id: [String],
      #       pledge_expected_fullfillment_date: [String],
      #       batch: [String],
      #       notes: [String],
      #       segment: [String],
      #       media_outlet: [String],
      #       receipt_date: [String],
      #       receipt_segment: [String],
      #       cash_accounting_code: [String],
      #       tribute: [String],
      #       tribute_dedication: {
      #         tribute_id: [Integer],
      #         tribute_type: [String],
      #         tribute_first_name: [String],
      #         tribute_last_name: [String],
      #         tribute_city: [String],
      #         tribute_state: [String],
      #         acknowledgee_individual_id: [Integer],
      #         acknowledgee_first_name: [String],
      #         acknowledgee_last_name: [String],
      #         acknowledgee_address: [String],
      #         acknowledgee_city: [String],
      #         acknowledgee_state: [String],
      #         acknowledgee_postal: [String],
      #         acknowledgee_email: [String],
      #         acknowledgee_phone: [String]
      #       },
      #       is_private: [Boolean],
      #       is_tax_deductible: [Boolean],
      #       check_number: [String],
      #       credit_card_type: [String],
      #       non_cash_gift_type_id: [Integer],
      #       non_cash_gift_type: [String],
      #       non_cash_gift_description: [String],
      #       stock_ticker_symbol: [String],
      #       stock_number_of_shares: [Integer],
      #       ira_custodian: [String],
      #       submission_url: [String],
      #       designations: [
      #         {
      #           id: [Integer],
      #           name: [String],
      #           code: [String],
      #           amount_designated: [String]
      #         }
      #       ],
      #       premiums: [
      #         {
      #           id: [Integer],
      #           name: [String],
      #           code: [String],
      #           quantity: [String]
      #         }
      #       ],
      #       custom_fields: [Hash],
      #       custom_objects: [
      #         {
      #           name: [String],
      #           fields: [
      #             {
      #               name: [String],
      #               value: [String]
      #             }
      #           ]
      #         }
      #       ],
      #       contact_individual_id: [Integer],
      #       passthrough_contact: [Contact],
      #       event_attendee: {
      #         event_id: [Integer],
      #         event_name: [String],
      #         invited: [Boolean],
      #         rsvp: [Boolean],
      #         rsvp_response: [Boolean],
      #         attended: [Boolean]
      #       }
      #     }
      #
      def import_gift(data)
        post('api/v2/Gift/Transaction', format(data))
      end

      ##
      # Creates a batch of gift transactions. This ensures the gift is matched using the Virtuous
      # matching algorithms for Contacts, Recurring gifts, Designations, etc.
      #
      # Transactions are posted to the API and are set to a holding state.
      # At midnight, transactions are bundled into imports based on the source they were posted
      # with.
      # The organization reviews the imported transactions, and then clicks run.
      #
      # @example
      #     client.import_gifts(
      #       transaction_source: 'Source', transactions: [
      #         {
      #           gift_type: 'Cash', amount: 10.5, currency_code: 'USD', gift_date: Date.today,
      #           contact: {
      #             contact_type: 'Organization', name: 'Org name', first_name: 'John',
      #             last_name: 'Doe', email: 'john_doe@email.com'
      #           }
      #         },
      #         {
      #           gift_type: 'Cash', amount: 5.0, currency_code: 'USD', gift_date: Date.today,
      #           contact: {
      #             contact_type: 'Organization', name: 'Org name', first_name: 'John',
      #             last_name: 'Doe', email: 'john_doe@email.com'
      #           }
      #         }
      #       ]
      #     )
      #
      # @param transactions [Array] An array of gifts. Refer to {#import_gift}
      #   to see a full list of accepted fields.
      # @param shared_fields [Hash] Shared fields for the transactions.
      # @option shared_fields [String] :transaction_source
      # @option shared_fields [Boolean] :create_import
      # @option shared_fields [String] :import_name
      # @option shared_fields [String] :batch
      # @option shared_fields [Float] :batch_total
      # @option shared_fields [String] :default_gift_date
      # @option shared_fields [String] :default_gift_type
      def import_gifts(transactions:, **shared_fields)
        shared_fields = shared_fields.slice(
          :transaction_source, :create_import, :import_name, :batch, :batch_total,
          :default_gift_date, :default_gift_type
        )

        post('api/v2/Gift/Transactions', format(shared_fields.merge(transactions: transactions)))
      end
    end
  end
end
