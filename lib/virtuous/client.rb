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
  #     client = Virtuous::Client.new
  #     client.authenticate(email, password)
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
  # #### Two-Factor Authentication
  #
  #     client = Virtuous::Client.new
  #     response = client.authenticate(email, password)
  #     if response[:requires_otp]
  #       # Prompt user for OTP
  #       client.authenticate(email, password, otp)
  #     end
  #
  # Check resource modules to see available client methods:
  #
  # - Virtuous::Client::Contact
  # - Virtuous::Client::Individual
  # - Virtuous::Client::Gift
  class Client
    include Virtuous::Client::Contact
    include Virtuous::Client::Individual
    include Virtuous::Client::Gift

    ##
    # Api key used for authentication.
    attr_reader :api_key
    ##
    # Base url that the client will use to form URLs.
    # default: `https://api.virtuoussoftware.com`.
    attr_reader :base_url
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
    # - `:access_token`: The OAuth access token.
    # - `:refresh_token`: The OAuth refresh token.
    # - `:expires_at`: The expiration date of the access token.
    def initialize(**config)
      read_config(config)

      @refreshed = false
    end

    ##
    # :method: get
    # :args: path, body = {}
    # Makes a `GET` request to the path.
    #
    # ### Params
    # - `path`: The path to send the request.
    # - `body`: Hash of URI query unencoded key/value pairs.
    #
    # ### Returns
    # The body of the response.

    ##
    # :method: post
    # :args: path, body = {}
    # Makes a `POST` request to the path.
    #
    # ### Params
    # - `path`: The path to send the request.
    # - `body`: Hash of URI query unencoded key/value pairs.
    #
    # ### Returns
    # The body of the response.

    ##
    # :method: delete
    # :args: path, body = {}
    # Makes a `DELETE` request to the path.
    #
    # ### Params
    # - `path`: The path to send the request.
    # - `body`: Hash of URI query unencoded key/value pairs.
    #
    # ### Returns
    # The body of the response.

    ##
    # :method: patch
    # :args: path, body = {}
    # Makes a `PATCH` request to the path.
    #
    # ### Params
    # - `path`: The path to send the request.
    # - `body`: Hash of URI query unencoded key/value pairs.
    #
    # ### Returns
    # The body of the response.

    ##
    # :method: put
    # :args: path, body = {}
    # Makes a `PUT` request to the path.
    #
    # ### Params
    # - `path`: The path to send the request.
    # - `body`: Hash of URI query unencoded key/value pairs.
    #
    # ### Returns
    # The body of the response.
    [:get, :post, :delete, :patch, :put].each do |http_method|
      define_method(http_method) do |path, body = {}|
        connection.public_send(http_method, path, body).body
      end
    end

    ##
    # Send a request to get an access token using the email and password of a user.
    #
    # ### Params
    # - `path`: The path to send the request.
    # - `body`: Hash of URI query unencoded key/value pairs.
    # - `otp`: One Time Password for users with two-factor authentication.
    #
    # ### Returns
    #
    #     # If the authentication was a success
    #     {
    #       access_token: '<access_token>',
    #       refresh_token: '<refresh_token>',
    #       expires_at: <expiration date>
    #     }
    #
    #     # If it requires Two-Factor Authentication
    #     {
    #       requires_otp: true
    #     }
    def authenticate(email, password, otp = nil)
      data = { grant_type: 'password', username: email, password: password }
      data[:otp] = otp unless otp.nil?
      get_access_token(data)
    end

    private

    def read_config(config)
      @api_key = config[:api_key] || ENV.fetch('VIRTUOUS_KEY', nil)
      @base_url = config[:base_url] || 'https://api.virtuoussoftware.com'
      @access_token = config[:access_token]
      @refresh_token = config[:refresh_token]
      @expires_at = config[:expires_at]
    end

    def use_access_token?
      !access_token.nil? || !refresh_token.nil?
    end

    def get_access_token(body)
      response = unauthorized_connection.post('/Token', URI.encode_www_form(body))

      return { requires_otp: true } if response.env.status == 202

      self.oauth_tokens = response.body

      { access_token: @access_token, refresh_token: @refresh_token, expires_at: @expires_at }
    end

    def oauth_tokens=(values)
      @access_token = values['access_token']
      @expires_at = Time.parse(values['.expires'])
      @refresh_token = values['refresh_token']
      @refreshed = true
    end

    def check_token_expiration
      if !refresh_token.nil? &&
         ((!expires_at.nil? && expires_at < Time.now) || access_token.nil?)
        get_access_token({ grant_type: 'refresh_token', refresh_token: refresh_token })
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
      if api_key.nil?
        check_token_expiration
        return access_token
      end

      api_key
    end

    def connection
      Faraday.new({ url: base_url }) do |conn|
        conn.request :json
        conn.request :authorization, 'Bearer', -> { bearer_token }
        conn.response :oj
        conn.use FaradayMiddleware::VirtuousErrorHandler
      end
    end

    def unauthorized_connection
      Faraday.new({ url: base_url }) do |conn|
        conn.request :json
        conn.response :oj
        conn.use FaradayMiddleware::VirtuousErrorHandler
      end
    end
  end
end
