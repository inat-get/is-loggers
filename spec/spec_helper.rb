require 'simplecov'
SimpleCov.start

require_relative '../lib/is-loggers'

RSpec.configure do |config|
  config.order = :random
  config.disable_monkey_patching!
end
