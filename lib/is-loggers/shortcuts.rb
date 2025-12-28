# frozen_string_literal: true

require_relative 'template-formatter'
require_relative 'telegram-device'
require_relative 'multilogger'

module IS 
  module Loggers; end
end

module IS::Loggers::Shortcuts

  CONSOLE_TEMPLATE = File.join __dir__, '..', 'share', 'console-log.erb'
  TELEGRAM_TEMPLATE = File.join __dir__, '..', 'share', 'console-log.erb'

  class << self

    def create_multilogger # TODO: args and implementation
    end

    def create_telegram_formatter # TODO: args and implementation
    end

    def create_console_formatter # TODO: args and implementation
    end

    def create_telegram_logger # TODO: args and implementation
    end

  end

end

require 'is-dsl'

module IL

  extend IS::DSL

  encapsulate IS::Loggers::Shortcuts, :create_multilogger, :create_console_formatter, :create_telegram_formatter, :create_telegram_logger

end
