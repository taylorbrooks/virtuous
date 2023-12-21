require_relative 'virtuous/version'
require_relative 'virtuous/error'
require_relative 'virtuous/parse_oj'
Dir[File.expand_path('virtuous/helpers/*.rb', __dir__)].sort.each { |f| require f }
require_relative 'virtuous/client'

##
# Virtuous module documentation.
#
# Go to Client to see the documentation of the client.
module Virtuous
end
