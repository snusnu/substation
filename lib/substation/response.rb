# encoding: utf-8

module Substation

  # Base class for action responses
  #
  # The following code illustrates context and serves as setup for all
  # instance method doc examples
  #
  #   module App
  #     class Environment
  #       def initialize(storage, logger)
  #         @storage, @logger = storage, logger
  #       end
  #     end
  #
  #     class SuccessfulAction
  #       def self.call(request)
  #         data = perform_work
  #         request.success(data)
  #       end
  #     end
  #
  #     class FailingAction
  #       def self.call(request)
  #         error = perform_work
  #         request.error(error)
  #       end
  #     end
  #   end
  #
  #   storage    = SomeStorageAbstraction.new
  #   env        = App::Environment.new(storage, Logger.new($stdout))
  #   dispatcher = Substation::Dispatcher.coerce({
  #     :successful_action => { :action => App::SuccessfulAction },
  #     :failing_action    => { :action => App::FailingAction }
  #   }, env)
  #
  # @abstract
  class Response

    include AbstractType
    include Concord::Public.new(:request, :output)
    include Adamantium::Flat

    alias_method :data, :output

    # The application environment used within an action
    #
    # @example
    #
    #   response = dispatcher.call(:successful_action, :some_input)
    #   response.env # => env passed to Substation::Dispatcher.coerce(config, env)
    #
    # @return [Object]
    #
    # @api public
    attr_reader :env

    # The request model instance passed into an action
    #
    # @example
    #
    #   response = dispatcher.call(:successful_action, :some_input)
    #   response.input # => :some_input
    #
    # @see Request#input
    #
    # @return [Object]
    #
    # @api public
    attr_reader :input

    # Initialize a new instance
    #
    # @param [Request] request
    #   the request passed to the action that returned this response
    #
    # @param [Object] output
    #   the data returned from the action that returned this response
    #
    # @return [undefined]
    #
    # @api private
    def initialize(request, output)
      super
      @env   = request.env
      @input = request.input
    end

    # Indicates wether this is a successful response or not
    #
    # @abstract
    #
    # @see Success#success?
    # @see Failure#success?
    #
    # @example
    #
    #   response = dispatcher.call(:successful_action, :some_input)
    #   response.success? # => true
    #
    # @return [Boolean]
    #   true if successful, false otherwise
    #
    # @api public
    abstract_method :success?

    # Test wether processing raised an exception
    #
    # @return [true]
    #
    # @api private
    def exception?
      false
    end

    # Return a {Request} instance built upon this response
    #
    # @return [Request]
    #
    # @api private
    def to_request(new_input = output)
      Request.new(request.name, env, new_input)
    end

  end # class Response
end # module Substation
