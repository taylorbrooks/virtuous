module Virtuous
  class Client
    module Individual
      ##
      # Fetches a individual record by email
      #
      #     client.find_individual_by_email('individual@email.com')
      #
      # ### Params
      # - `email` [String] The email of the individual
      #
      # ### Returns
      # The individual information in a hash
      def find_individual_by_email(email)
        serialize(get('api/ContactIndividual/Find', { email: email }))
      end
    end
  end
end
