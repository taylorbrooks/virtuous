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
  #
  # Check resource modules to see available client methods:
  #
  # - Virtuous::Client::Contact
  # - Virtuous::Client::Individual
  # - Virtuous::Client::Gift
  class Client
    include Virtuous::Client::Contact
    include Virtuous::Client::Individual

    ##
    # Access token used for OAuth authentication.
    attr_reader :access_token
    ##
    # Token used to refresh the access token when it has expired.
    attr_reader :refresh_token
    ##
    # Expiration date of the access token.
    attr_reader :expires_at
    ##
    # True if the access token has been refreshed.
    attr_reader :refreshed

    ##
    # ### Options
    #
    # - `:base_url`: The base url to use for API calls.
    # default: `https://api.virtuoussoftware.com`.
    # - `:api_key`: The key for the API.
    # - `:email`: The email of the OAuth user.
    # - `:password`: The password of the OAuth user.
    # - `:access_token`: The OAuth access token.
    # - `:refresh_token`: The OAuth refresh token.
    # - `:expires_at`: The expiration date of the access token.
    # - `:logger`: If true, the client will log internal events in the HTTP request lifecycle.
    #
    # ### Authentication
    #
    # #### Api key auth
    #
    # To generate an api key you need to visit the
    # [virtuous connect dashboard](https://connect.virtuoussoftware.com/).
    # Then you can use the key by setting the `api_key` param while creating the client or
    # by setting the `VIRTUOUS_KEY` environment variable beforehand.
    #
    # #### Oauth
    #
    # First, an access token needs to be fetched by providing a user's email and password.
    # This will return an access token that lasts for 15 days, and a refresh token that should be
    # stored and used to create clients in the future.
    # The client will use the expiry date of the access token to automatically determine when a
    # new one needs to be fetched.
    #
    #     client = Virtuous::Client.new(email: user.email, password: password)
    #     user.update(
    #       access_token: client.access_token, refresh_token: client.refresh_token,
    #       token_expiration: client.expires_at
    #     )
    #
    #     # Afterwards
    #
    #     client = Virtuous::Client.new(
    #       access_token: user.access_token, refresh_token: user.refresh_token,
    #       expires_at: user.token_expiration
    #     )
    #
    #     # Use client
    #
    #     if client.refreshed
    #       # Update values if they changed
    #       user.update(
    #         access_token: client.access_token, refresh_token: client.refresh_token,
    #         token_expiration: client.expires_at
    #       )
    #     end
    #
    def initialize(config)
      read_config(config)

      @refreshed = false

      return unless @api_key.nil?

      return if use_access_token?

      authenticate(config[:email], config[:password])
    end

    [:get, :post, :delete, :patch, :put].each do |http_method|
      define_method(http_method) do |path, options = {}|
        connection.public_send(http_method, path, options).body
      end
    end

    private

    def authenticate(email, password)
      raise ArgumentError, 'No valid authentication options' unless email && password

      data = { grant_type: 'password', username: email, password: password }
      get_access_token(data)
    end

    def read_config(config)
      [:base_url, :api_key, :access_token, :refresh_token, :expires_at, :logger].each do |attribute|
        instance_variable_set("@#{attribute}", config[attribute])
      end

      @api_key ||= ENV.fetch('VIRTUOUS_KEY', nil)
      @base_url ||= 'https://api.virtuoussoftware.com'
    end

    def use_access_token?
      !@access_token.nil? || !@refresh_token.nil?
    end

    def get_access_token(body)
      response = unauthorized_connection.post('/Token', URI.encode_www_form(body)).body
      @access_token = response['access_token']
      @expires_at = Time.parse(response['.expires'])
      @refresh_token = response['refresh_token']
      @refreshed = true
    end

    def check_token_expiration
      if !@refresh_token.nil? &&
         ((!@expires_at.nil? && @expires_at < Time.now) || @access_token.nil?)
        get_access_token({ grant_type: 'refresh_token', refresh_token: @refresh_token })
      end
    end

    def parse(data)
      data = JSON.parse(data) if data.is_a?(String)

      data.deep_transform_keys { |key| key.underscore.to_sym }
    end

    def format(data)
      data.deep_transform_keys { |key| key.to_s.camelize }
    end

    def bearer_token
      if @api_key.nil?
        check_token_expiration
        return @access_token
      end

      @api_key
    end

    def connection
      Faraday.new({ url: @base_url }) do |conn|
        conn.request :json
        conn.request :authorization, 'Bearer', -> { bearer_token }
        conn.response :oj
        conn.response :logger if @logger
        conn.use FaradayMiddleware::VirtuousErrorHandler
      end
    end

    def unauthorized_connection
      Faraday.new({ url: @base_url }) do |conn|
        conn.request :json
        conn.response :oj
        conn.response :logger if @logger
        conn.use FaradayMiddleware::VirtuousErrorHandler
      end
    end
  end
end
