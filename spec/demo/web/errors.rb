# encoding: utf-8

class Demo
  module Web
    class Error < Core::Error
      SanitizationError = Class.new(self)
    end
  end
end
