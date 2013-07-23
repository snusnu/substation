# encoding: utf-8

class Demo
  module Core
    class Error
      include Concord::Public.new(:object)
      include Adamantium::Flat

      InternalError       = Class.new(self)
      ApplicationError    = Class.new(self)
      AuthenticationError = Class.new(self)
      AuthorizationError  = Class.new(self)
      ValidationError     = Class.new(self)
    end
  end
end
