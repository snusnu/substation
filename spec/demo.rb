# encoding: utf-8

require 'demo/web'

class Demo

  logger   = Object.new # some logger instance
  storage  = Object.new # some database abstraction e.g. ROM::Environment
  env_name = ::ENV.fetch('APP_ENV', :development)

  APP_ENV = Environment.build(env_name, storage, logger)

end

require 'demo/core/facade'
require 'demo/web/facade'
