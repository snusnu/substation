# encoding: utf-8

require 'pp'

require 'anima'
require 'ducktrap'
require 'vanguard'
require 'substation'

class Demo

  Undefined = Object.new.freeze

  ACCOUNTS = {
    1 => { :name => 'Jane', :privileges => [ :create_person ] },
    2 => { :name => 'Mr.X', :privileges => [] }
  }

end

require 'demo/environment'

require 'demo/core/models/person'
require 'demo/core/errors'
require 'demo/core/input'
require 'demo/core/actor'
require 'demo/core/handler'
require 'demo/core/handler/authenticator'
require 'demo/core/handler/authorizer'
require 'demo/core/handler/acceptor'
require 'demo/core/validator'
require 'demo/core/validator/person'
require 'demo/core/action'
require 'demo/core/action/create_person'
require 'demo/core/observers'
