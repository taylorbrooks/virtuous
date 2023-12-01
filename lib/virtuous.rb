require_relative 'virtuous/version'
require_relative 'virtuous/error'
require_relative 'virtuous/parse_oj'
Dir[File.expand_path('virtuous/extensions/*.rb', __dir__)].sort.each { |f| require f }
require_relative 'virtuous/client'

##
# Virtuous module documentation.
module Virtuous
end
