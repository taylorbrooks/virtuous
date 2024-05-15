require 'faraday'

module Virtuous # :nodoc: all
  class Error < StandardError; end
  class BadGateway < Error; end
  class BadRequest < Error; end
  class CloudflareError < Error; end
  class Forbidden < Error; end
  class GatewayTimeout < Error; end
  class InternalServerError < Error; end
  class NotFound < Error; end
  class ServiceUnavailable < Error; end
  class Unauthorized < Error; end

  module FaradayMiddleware
    class VirtuousErrorHandler < Faraday::Middleware
      ERROR_STATUSES = (400..600).freeze

      ##
      # Throws an exception for responses with an HTTP error code.
      def on_complete(env)
        message = error_message(env)

        case env[:status]
        when 400
          raise Virtuous::BadRequest, message
        when 401
          raise Virtuous::Unauthorized, message
        when 403
          raise Virtuous::Forbidden, message
        when 404
          raise Virtuous::NotFound, message
        when 500
          raise Virtuous::InternalServerError, message
        when 502
          raise Virtuous::BadGateway, message
        when 503
          raise Virtuous::ServiceUnavailable, message
        when 504
          raise Virtuous::GatewayTimeout, message
        when 520
          raise Virtuous::CloudflareError, message
        when ERROR_STATUSES
          raise Virtuous::Error, message
        end
      end

      private

      def error_message(env)
        "#{env[:status]}: #{env[:url]} #{env[:body]}"
      end
    end
  end
end
