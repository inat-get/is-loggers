# frozen_string_literal: true

require 'yaml'
require 'erb'
require 'logger'

module IS
  module Loggers; end
end

class IS::Loggers::TemplateFormatter

  DEFAULT_ICONS = {
    :debug   => '🔍',
    :info    => '📢',
    :warn    => '🔔',
    :error   => '🚨',
    :fatal   => '🛑',
    :unknown => '❓'
  }.freeze

  DEFAULT_DATETIME_FORMAT = "%Y.%m.%d %H:%M:%S.%N %Z"

  attr_accessor :program, :datetime_format

  def initialize template, program: '', datetime_format: DEFAULT_DATETIME_FORMAT
    @template, @data = parse_template template
    @renderer = ERB::new @template, trim_mode: '-'
    @program = program
    @datetime_format = datetime_format
  end

  def call severity, datetime, program, message
    icons = get_icons_hash
    level = get_level_key severity
    vars = {
      severity: severity,
      datetime: datetime.strftime(@datetime_format),
      time: datetime,
      program: program || @program,
      message: msg2str(message),
      level: level,
      icon: icons[level],
      icons: icons,
      template_data: data,
      pid: Process.pid
    }
    @renderer.result_with_hash vars
  rescue => e
    warn msg2str(e), uplevel: 1
  end

  private

  def parse_template template
    data = {}
    content = nil
    if template.lines(chomp: true).first == '---'
      docs = template.split(/^---\n/m, 3)
      data = if docs[0].strip.empty? && docs[1]
        YAML.safe_load docs[1], symbolize_names: true
      else
        YAML.safe_load docs[0], symbolize_names: true
      end || {}
      content = docs[2] || docs[1] || template
    else
      content = template
    end
    [ content, data ]
  end

  def get_level_key severity
    case severity
    when Logger::DEBUG
      :debug
    when Logger::INFO
      :info
    when Logger::WARN
      :warn
    when Logger::ERROR
      :error
    when Logger::FATAL
      :fatal
    else 
      :unknown
    end
  end

  def get_icons_hash
    if Hash === @data && Hash === @data[:icons]
      DEFAULT_ICONS.merge(@data[:icons]).freeze
    else
      DEFAULT_ICONS
    end
  end

  def msg2str msg
    case msg
    when ::String
      msg
    when ::Exception
      "#{ msg.message } (#{ msg.class })\n#{ msg.backtrace.join("\n") if msg.backtrace }"
    else
      msg.inspect
    end
  end

  class << self

    def from_file filename, program: '', datetime_format: DEFAULT_DATETIME_FORMAT
      new File.read(filename), program: program, datetime_format: datetime_format
    end

  end

end

require 'is-dsl'

module IL

  extend IS::DSL

  encapsulate IS::Loggers::TemplateFormatter, :new => :create_template_formatter, :from_file => :create_template_formatter_from_file

end
