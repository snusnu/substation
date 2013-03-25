module Substation

  @actions = Action::Registry.new

  def self.actions
    @actions
  end

  def self.register(action)
    actions.register(action)
  end

  class Action

    def self.inherited(descendant)
      super
      Substation.register(descendant) unless unregistered?(descendant)
    end

    private_class_method :inherited

    def self.unregistered_action_names
      @unregistered_action_names ||= Set.new
    end

    def self.unregistered?(action)
      unregistered_action_names.include?(action.name)
    end

    def self.call(session, params)
      new(Substation::Action::Request.new(self, session, params)).call
    end

    def self.params=(params_klass)
      @params = params_klass
    end

    def self.params
      @params
    end

    include AbstractType
    extend  Forwardable

    attr_reader :request
    attr_reader :response

    def_delegator :request, :session
    def_delegator :session, :actor

    def initialize(request)
      @request  = request
      @response = self.class::Response.new(@request)
    end

    def call
      return response if called?
      invoke
      @called = true
      response
    rescue StandardError => e
      raise e if ENV['DEBUG']
      response
    end

    private

    def perform
      raise NotImplementedError, "#{self.class}##{__method__} must be implemented"
    end

    def invoke
      perform
    end

    def called?
      @called
    end
  end # class Action
end # module Substation
