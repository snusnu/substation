# encoding: utf-8

module Substation

  # Namespace for chain processors
  module Processor

    # Test wether chain processing should continue
    #
    # @param [Response] response
    #   the response returned from invoking the processor
    #
    # @return [true] for a successful response
    # @return [false] otherwise
    #
    # @api private
    def success?(response)
      response.success?
    end

    # The response passed on to the next processor in a {Chain}
    #
    # @param [Response] response
    #   the response returned from invoking the processor
    #
    # @return [Response]
    #   the response passed on to the next processor in a {Chain}
    #
    # @api private
    def result(response)
      response
    end

    module Fallible
      include Concord.new(:name, :handler, :failure_chain)

      # This processor's name
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :name

      # Return a new processor with +chain+ as failure_chain
      #
      # @param [#call] chain
      #   the failure chain to use for the new processor
      #
      # @return [#call]
      #
      # @api private
      def with_failure_chain(chain)
        self.class.new(name, handler, chain)
      end
    end

    module Incoming
      include Processor
      include Fallible

      # The request passed on to the next processor in a {Chain}
      #
      # @param [Response] _response
      #   the response returned from invoking this processor
      #
      # @return [Request]
      #   the request passed on to the next processor in a {Chain}
      #
      # @api private
      def result(_response)
        super.to_request
      end
    end

    module Pivot
      include Processor
      include Fallible
    end

    module Outgoing
      include Concord.new(:name, :handler)
      include Processor

      # This processor's name
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :name

      # Test wether chain processing should continue
      #
      # @param [Response] _response
      #   the response returned from invoking the processor
      #
      # @return [false]
      #
      # @api private
      def success?(_response)
        true
      end

      private

      # Build a new {Response} based on +response+ and +output+
      #
      # @param [Response] response
      #   the original response
      #
      # @param [Object] output
      #   the data to be wrapped within the new {Response}
      #
      # @return [Response]
      #
      # @api private
      def respond_with(response, output)
        response.class.new(response.request, output)
      end

    end # module Outgoing

    # Namespace for modules that help with processor api compatibility
    module API

      # Indicate successful processing
      module Success

        # Test wether evaluation was successful
        #
        # @return [true]
        #
        # @api private
        def success?
          true
        end
      end

      # Indicate errorneous processing
      module Failure

        # Test wether evaluation was successful
        #
        # @return [false]
        #
        # @api private
        def success?
          false
        end
      end

      # Helps returning an api compatible result from custom Evaluator handlers
      class Responder < Module

        include Concord.new(:base_response)
        include Adamantium::Flat

        # Mapping of method names to class names
        API_METHOD_MAPPING = {
          :success => :Success,
          :error   => :Failure
        }.freeze

        # Hook called when module is included
        #
        # @param [Class|Module] host
        #   the object the module is being included in
        #
        # @return [undefined]
        #
        # @api private
        def included(host)
          define_api_methods(host)
          define_abstract_helper_method(host)
        end

        private

        # Defines public responder methods on host
        #
        # @param [Class, Module] host
        #   the object hosting this module
        #
        # @return [undefined]
        #
        # @api private
        def define_api_methods(host)
          API_METHOD_MAPPING.each do |method_name, class_name|
            klass = base_response.const_get(class_name)
            define_api_method(host, method_name, klass)
          end
        end

        # Defines a public responder method on host
        #
        # @param [Class, Module] host
        #   the object hosting this module
        #
        # @param [Symbol] method_name
        #   the responder method's name
        #
        # @param [Class] klass
        #   the class constructing the response
        #
        # @return [undefined]
        #
        # @api private
        def define_api_method(host, method_name, klass)
          host.class_eval do
            define_method(method_name) do |output|
              respond_with(klass, output)
            end
          end
        end

        # Defines private abstract responder helper method on host
        #
        # @param [Class, Module] host
        #   the object hosting this module
        #
        # @return [undefined]
        #
        # @api private
        def define_abstract_helper_method(host)
          host.class_eval do
            define_method(:respond_with) do |_klass, _output|
              msg = "#{self.class}##{__method__} must be implemented"
              raise NotImplementedError, msg
            end
          end
        end
      end # module Responder

    end
  end # module Processor
end # module Substation
