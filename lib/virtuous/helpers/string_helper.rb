module Virtuous
  ##
  # Helper methods for strings
  class StringHelper
    class << self
      ##
      # Transform a String from `CamelCase` to `snake_case`.
      # @param string [String] the string to transform.
      # @return [String] the `snake_case` string.
      def underscore(string)
        string.gsub('::', '/')
              .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
              .gsub(/([a-z\d])([A-Z])/, '\1_\2')
              .tr('-', '_')
              .downcase
      end

      ##
      # Transform a String from `snake_case` to `CamelCase`.
      # @param string [String] the string to transform.
      # @return [String] the `CamelCase` string.
      def camelize(string)
        string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/, &:downcase)

        string.gsub(%r{(?:_|(/))([a-z\d]*)}) do
          "#{::Regexp.last_match(1)}#{::Regexp.last_match(2).capitalize}"
        end.gsub('/', '::')
      end
    end
  end
end
