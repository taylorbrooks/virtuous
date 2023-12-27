module Virtuous
  class Client
    ##
    # ### Contact Address data
    #
    #     {
    #       contact_id: [Integer],
    #       label: [String],
    #       address1: [String],
    #       address2: [String],
    #       city: [String],
    #       state: [String],
    #       postal: [String],
    #       country: [String],
    #       set_as_primary: [Boolean],
    #       start_month: [Integer],
    #       start_day: [Integer],
    #       end_month: [Integer],
    #       end_day: [Integer]
    #     }
    #
    module ContactAddress
      ##
      # Gets the addresses of a contact.
      #
      # @example
      #     client.get_contact_addresses(1)
      #
      # @param contact_id [Integer] The id of the Contact.
      #
      # @return [Array] An array with all the addresses of a contact.
      #
      def get_contact_addresses(contact_id)
        response = get("api/ContactAddress/ByContact/#{contact_id}")
        response.map { |address| parse(address) }
      end

      ##
      # Updates an address.
      #
      # @example
      #     client.update_contact_address(
      #       1, label: 'Home address', address1: '324 Frank Island', address2: 'Apt. 366',
      #       city: 'Antonioborough', state: 'Massachusetts', postal: '27516', country: 'USA'
      #     )
      #
      # @note Excluding a property will remove it's value from the object.
      # If you're only updating a single property, the entire model is still required.
      #
      # @param id [Integer] The id of the address to update.
      # @param data [Hash] A hash containing the address details.
      #   Refer to the data section above to see the available attributes.
      #
      # @return [Hash] The address that has been updated.
      def update_contact_address(id, data)
        parse(put("api/ContactAddress/#{id}", format(data)))
      end

      ##
      # Creates an address.
      #
      # @example
      #     client.create_contact_address(
      #       contact_id: 1, label: 'Home address', address1: '324 Frank Island',
      #       address2: 'Apt. 366', city: 'Antonioborough', state: 'Massachusetts', postal: '27516',
      #       country: 'USA'
      #     )
      #
      # @param data [Hash] A hash containing the address details.
      #   Refer to the data section above to see the available attributes.
      #
      # @return [Hash] The address that has been created.
      def create_contact_address(data)
        parse(post('api/ContactAddress', format(data)))
      end
    end
  end
end
