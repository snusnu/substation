module Substation
  class Action
    class Handler

      class Installer

        private_class_method :new

        def self.install(host, method, options)
          new(host, method, options).install
        end

        def self.base_handler=(handler)
          @base_handler = handler
        end

        def self.base_handler
          @base_handler ||= Handler
        end

        def initialize(host, method, options)
          @host         = host
          @options      = options
          @handler_name = self.class.base_handler.class_name(method)
        end

        def install
          @handler_class = Class.new(base_handler)
          @host.const_set(@handler_name, @handler_class)

          @handler_class = @host.const_get(@handler_name)

          @handler_class.controller = @host
          @handler_class.presenter  = @options[:presenter]
          @handler_class.resource(@options[:resource])
          self
        end

        def base_handler
          handler = self.class.base_handler
          handler.const_get(@handler_name)
        rescue
          handler
        end
      end # class Installer
    end # class Handler
  end # class Action
end # module Substation
