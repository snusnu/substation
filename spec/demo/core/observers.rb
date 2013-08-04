# encoding: utf-8

class Demo
  module Core

    module Observers

      class Observer
        def call(response)
        end

        def freeze
          raise
        end
      end

      LOG_EVENT  = Observer.new
      SEND_EMAIL = Observer.new
    end
  end
end
