require 'picatcha/configuration'
require 'picatcha/client_helper'
require 'picatcha/verify'

module Picatcha
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 0
    TINY  = 0
    PATCH = 1

    STRING = [MAJOR, MINOR, TINY, PATCH].join('.')
  end


  PICATCHA_API_SERVER_URL        = 'http://api.picatcha.com' #'http://www.google.com/recaptcha/api'
  PICATCHA_API_SECURE_SERVER_URL = #'https://www.google.com/recaptcha/api'
  PICATCHA_VERIFY_URL            = 'http://api.picatcha.com/v' #'http://www.google.com/recaptcha/api/verify'

  SKIP_VERIFY_ENV = ['test', 'cucumber']

  # Gives access to the current Configuration.
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Allows easy setting of multiple configuration options. See Configuration
  # for all available options.
  #--
  # The temp assignment is only used to get a nicer rdoc. Feel free to remove
  # this hack.
  #++
  def self.configure
    config = configuration
    yield(config)
  end

  def self.with_configuration(config)
    original_config = {}

    config.each do |key, value|
      original_config[key] = configuration.send(key)
      configuration.send("#{key}=", value)
    end

    result = yield if block_given?

    original_config.each { |key, value| configuration.send("#{key}=", value) }
    result
  end

  class PicatchaError < StandardError
  end
end

if defined?(Rails)
  require 'picatcha/rails'
end
