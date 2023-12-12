require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :environment do
  require 'dotenv'
  Dotenv.load

  $LOAD_PATH.unshift File.expand_path('lib', __dir__)
  require 'virtuous'
end

desc 'Launch a pry shell with libraries loaded'
task pry: :environment do
  @client = Virtuous::Client.new(logger: !ENV['CLIENT_LOGGER'].nil?) if ENV['VIRTUOUS_KEY']

  require 'pry'
  Pry.start
end
