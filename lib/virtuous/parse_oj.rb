require 'oj'

module FaradayMiddleware
  class ParseOj < Faraday::Middleware
    ##
    # Parses JSON responses
    def on_complete(env)
      body = env[:body]
      env[:body] = if empty_body?(body.strip)
                     nil
                   else
                     Oj.load(body, mode: :compat)
                   end
    end

    private

    def empty_body?(body)
      body.empty? && body == ''
    end
  end
end

Faraday::Response.register_middleware(oj: FaradayMiddleware::ParseOj)
