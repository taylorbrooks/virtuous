module Virtuous
  class Client
    module Contact
      ##
      # Fetches a contact record by email
      #
      #     client.find_contact_by_email('contact@email.com')
      #
      # ### Params
      # - `email` [String] The email of the contact
      #
      # ### Returns
      # The contact information in a hash
      def find_contact_by_email(email)
        serialize(get('api/Contact/Find', { email: email }))
      end
    end
  end
end
