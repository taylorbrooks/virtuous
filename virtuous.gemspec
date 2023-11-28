require 'English'
$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'virtuous/version'

Gem::Specification.new do |s|
  s.name          = 'virtuous'
  s.version       = Virtuous::VERSION
  s.authors       = ['Taylor Brooks']
  s.homepage      = 'https://github.com/taylorbrooks/virtuous'
  s.summary       = 'A Ruby wrapper for the Virtuous CRM API'
  s.description   = 'A Ruby wrapper for the Virtuous CRM API'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.executables   = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  s.required_ruby_version = '>= 2.7'

  s.require_paths = ['lib']
  s.metadata['rubygems_mfa_required'] = 'true'
end
