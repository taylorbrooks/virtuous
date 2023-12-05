require 'faraday'

Dir[File.expand_path('client/*.rb', __dir__)].sort.each { |f| require f }

module Virtuous
  ##
  # An API client for Virtuous. To construct a client, you need to configure the `:api_key`.
  #
  #     client = Virtuous::Client.new(
  #       api_key: api_key,
  #       # ...
  #     )
  #
  # See Virtuous::Client::new for a full list of supported configuration options.
  class Client
    include Virtuous::Client::Contact
    include Virtuous::Client::Individual

    attr_reader :api_key, :base_url

    ##
    # To be able to create a client, you need to set the api_key.
    # This can also be done by setting the `VIRTUOUS_KEY` environment variable.
    #
    # :args: api_key:, base_url:
    #
    # ### Options
    # - `:api_key`: The key for the API.
    # - `:base_url`: The base url to use for API calls.
    def initialize(api_key: ENV.fetch('VIRTUOUS_KEY', nil), base_url: 'https://api.virtuoussoftware.com')
      raise ArgumentError, 'api_key is required' if api_key.nil?

      @api_key = api_key
      @base_url = base_url
    end

    [:get, :post, :delete, :patch, :put].each do |http_method|
      define_method(http_method) do |path, options = {}|
        connection.public_send(http_method, path, options).body
      end
    end

    private

    def parse(data)
      data = JSON.parse(data) if data.is_a?(String)

      data.deep_transform_keys { |key| key.underscore.to_sym }
    end

    def format(data)
      data.deep_transform_keys { |key| key.to_s.camelize }
    end

    def connection
      Faraday.new({ url: base_url }) do |conn|
        conn.request :json
        conn.request :authorization, 'Bearer', -> { api_key }
        conn.response :oj
        conn.use FaradayMiddleware::VirtuousErrorHandler
      end
    end
  end
end
