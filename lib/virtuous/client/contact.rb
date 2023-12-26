module Virtuous
  class Client
    ##
    # ### Contact data
    #
    #     {
    #       contact_type: [String],
    #       reference_source: [String],
    #       reference_id: [String],
    #       name: [String],
    #       informal_name: [String],
    #       description: [String],
    #       website: [String],
    #       marital_status: [String],
    #       anniversary_month: [Integer],
    #       anniversary_day: [Integer],
    #       anniversary_year: [Integer],
    #       origin_segment_id: [Integer],
    #       is_private: [Boolean],
    #       is_archived: [Boolean],
    #       contact_addresses: [
    #         {
    #           label: [String],
    #           address1: [String],
    #           address2: [String],
    #           city: [String],
    #           state_code: [String],
    #           postal: [String],
    #           country_code: [String],
    #           is_primary: [Boolean],
    #           latitude: [Float],
    #           longitude: [Float]
    #         }
    #       ],
    #       contact_individuals: [
    #         {
    #           first_name: [String],
    #           last_name: [String],
    #           prefix: [String],
    #           middle_name: [String],
    #           suffix: [String],
    #           birth_month: [Integer],
    #           birth_day: [Integer],
    #           birth_year: [Integer],
    #           approximate_age: [Integer],
    #           gender: [String],
    #           passion: [String],
    #           is_primary: [Boolean],
    #           is_secondary: [Boolean],
    #           is_deceased: [Boolean],
    #           contact_methods: [
    #             {
    #               type: [String],
    #               value: [String],
    #               is_opted_in: [Boolean],
    #               is_primary: [Boolean]
    #             }
    #           ],
    #           custom_fields: [Hash]
    #         }
    #       ],
    #       custom_fields: [Hash],
    #       custom_collections: [
    #         {
    #           name: [String],
    #           fields: [
    #             {
    #               name: [String],
    #               value: [String]
    #             }
    #           ]
    #         }
    #       ]
    #     }
    #
    module Contact
      ##
      # Fetches a contact record by email.
      #
      # @example
      #     client.find_contact_by_email('contact@email.com')
      #
      # @param email [String] The email of the contact.
      #
      # @return [Hash] The contact information in a hash.
      def find_contact_by_email(email)
        parse(get('api/Contact/Find', { email: email }))
      end

      ##
      # Fetches a contact record by id.
      #
      # @example
      #     client.get_contact(1)
      #
      # @param id [Integer] The id of the contact.
      #
      # @return [Hash] The contact information in a hash.
      def get_contact(id)
        parse(get("api/Contact/#{id}"))
      end

      ##
      # Creates a contact. This will use the virtuous import tool to match the new contact
      # with existing ones. If the contact record exists already but there is new
      # information the record will be flagged for review.
      #
      # Transactions are posted to the API and are set to a holding state.
      # At midnight, transactions are bundled into imports based on the source they were posted
      # with.
      # The organization reviews the imported transactions, and then clicks run.
      #
      # @example
      #     client.import_contact(
      #       contact_type: 'Organization', name: 'Org name',
      #       first_name: 'John', last_name: 'Doe'
      #     )
      #
      # @param data [Hash] A hash containing the contact details.
      #
      # #### Required fields
      # - `contact_type`: "Household", "Organization", "Foundation" or a custom type.
      # - `contact_name`: required if Organization or Foundation.
      # - `first_name`
      # - `last_name`
      #
      # #### Suggested fields
      # - `reference_source`: the system it came from.
      # - `reference_id`: the ID in the original system.
      # - `email`
      # - `phone`
      # - `address`
      #
      # #### Full list of accepted fields
      #
      #     {
      #       reference_source: [String],
      #       reference_id: [String],
      #       contact_type: [String],
      #       name: [String],
      #       title: [String],
      #       first_name: [String],
      #       middle_name: [String],
      #       last_name: [String],
      #       suffix: [String],
      #       email_type: [String],
      #       email: [String],
      #       phone_type: [String],
      #       phone: [String],
      #       address1: [String],
      #       address2: [String],
      #       city: [String],
      #       state: [String],
      #       postal: [String],
      #       country: [String],
      #       event_id: [Integer],
      #       event_name: [String],
      #       invited: [Boolean],
      #       rsvp: [Boolean],
      #       rsvp_response: [Boolean],
      #       attended: [Boolean],
      #       tags: [String],
      #       origin_segment_code: [String],
      #       email_lists: [String[]],
      #       custom_fields: [Hash],
      #       volunteer_attendances: [
      #         {
      #           volunteer_opportunity_id: [Integer],
      #           volunteer_opportunity_name: [String],
      #           date: [String],
      #           hours: [String]
      #         }
      #       ]
      #     }
      #
      def import_contact(data)
        post('api/Contact/Transaction', format(data))
      end

      ##
      # Creates a contact.
      #
      # @example
      #     client.create_contact(
      #       contact_type: 'Organization', name: 'Org name',
      #       contact_individuals: [
      #         { first_name: 'John', last_name: 'Doe' }
      #       ]
      #     )
      #
      # @param data [Hash] A hash containing the contact details.
      #   Refer to the [Contact data](#label-Contact+data) section
      #   above to see the available attributes.
      #
      # @return [Hash] The contact that has been created.
      def create_contact(data)
        parse(post('api/Contact', format(data)))
      end

      ##
      # Updates a contact.
      #
      # @example
      #     client.update_contact(1, contact_type: 'Organization', name: 'New name')
      #
      # @note Excluding a property will remove it's value from the object.
      # If you're only updating a single property, the entire model is still required.
      #
      # @param id [Integer] The id of the contact to update.
      # @param data [Hash] A hash containing the contact details.
      #   Refer to the [Contact data](#label-Contact+data) section
      #   above to see the available attributes.
      #
      # @return [Hash] The contact that has been updated.
      def update_contact(id, data)
        parse(put("api/Contact/#{id}", format(data)))
      end
    end
  end
end
