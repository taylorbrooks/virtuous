module Virtuous
  class Client
    ##
    # ### Individual data
    #
    #     {
    #       contact_id: [Integer],
    #       first_name: [String],
    #       last_name: [String],
    #       contact_methods: [
    #         {
    #           type: [String],
    #           value: [String],
    #           is_opted_in: [Boolean],
    #           is_primary: [Boolean]
    #         }
    #       ],
    #       prefix: [String],
    #       middle_name: [String],
    #       suffix: [String],
    #       gender: [String],
    #       set_as_primary: [Boolean],
    #       set_as_secondary: [Boolean],
    #       birth_month: [Integer],
    #       birth_day: [Integer],
    #       birth_year: [Integer],
    #       approximate_age: [Integer],
    #       is_deceased: [Boolean],
    #       deceased_date: [Date],
    #       passion: [String],
    #       avatar_url: [String],
    #       custom_fields: [
    #         {
    #           name: [String],
    #           value: [String],
    #           display_name: [String]
    #         }
    #       ],
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
    module Individual
      ##
      # Fetches an individual record by email.
      #
      #     client.find_individual_by_email('individual@email.com')
      #
      # ### Params
      # - `email`: The email of the individual.
      #
      # ### Returns
      # The individual information in a hash.
      def find_individual_by_email(email)
        parse(get('api/ContactIndividual/Find', { email: email }))
      end

      ##
      # Fetches an individual record by id.
      #
      #     client.get_individual(1)
      #
      # ### Params
      # - `id`: The id of the individual.
      #
      # ### Returns
      # The individual information in a hash.
      def get_individual(id)
        parse(get("api/ContactIndividual/#{id}"))
      end

      ##
      # Creates an individual.
      #
      #     client.create_individual(first_name: 'John', last_name: 'Doe', contact_id: 1)
      #
      # ### Params
      # - `data`: A hash containing the individual details.
      # Refer to the [Individual data](#module-Virtuous::Client::Individual-label-Individual+data)
      # section above to see the available attributes.
      #
      # ### Returns
      # The individual that has been created.
      def create_individual(data)
        parse(post('api/ContactIndividual', format(data)))
      end

      ##
      # Updates an individual.
      #
      #     client.update_individual(1, first_name: 'New', last_name: 'Name')
      #
      # Excluding a property will remove it's value from the object.
      # If you're only updating a single property, the entire model is still required.
      #
      # ### Params
      # - `id`: The id of the individual to update.
      # - `data`: A hash containing the individual details.
      # Refer to the [Individual data](#module-Virtuous::Client::Individual-label-Individual+data)
      # section above to see the available attributes.
      #
      # ### Returns
      # The individual that has been updated.
      def update_individual(id, data)
        parse(put("api/ContactIndividual/#{id}", format(data)))
      end

      ##
      # Delete an individual.
      #
      #     client.delete_individual(1)
      #
      # ### Params
      # - `id`: The id of the individual to delete.
      def delete_individual(id)
        delete("api/ContactIndividual/#{id}")
      end
    end
  end
end
