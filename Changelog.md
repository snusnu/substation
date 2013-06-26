# v0.0.9 (not yet released)

* [BREAKING CHANGE] Refactor `Substation::Processor` classes.

  * Renamed `Substation::Processor::Evaluator` to `Substation::Processor::Evaluator::Data`.
  * Renamed `Substation::Processor::Pivot` to `Substation::Processor::Evaluator::Pivot`.
  * Added `Substation::Processor::Evaluator::Request` which passes the complete `Request` instance on to the handler.
  * Added `Substation::Processor::Transformer` to transform response output into any other object.

* [feature] Make the dispatched name available in Request#name

* [feature] Support definining failure chains for incoming processors

        env = Substation::Environment.build do
          register :validate, Substation::Processor::Evaluator::Data
          register :call,     Substation::Processor::Evaluator::Pivot
        end

        class Error
          attr_reader :data
          def initialize(data)
            @data = data
          end

          ValidationError = Class.new(self)
          InternalError   = Class.new(self)
        end

        chain = env.chain do
          validate(Vanguard::Validator) { wrap Error::ValidationError }
          call(Some::Action) { wrap Error::InternalError }
        end

        env             = Object.new
        name            = :some_name
        invalid_request = Substation::Request.new(name, env, :invalid)
        response        = chain.call(invalid_request)

        response.data.instance_of?(Errors::ValidationError)
        # => true

        response.data.data # => the actual vanguard violation set

[Compare v0.0.8..master](https://github.com/snusnu/substation/compare/v0.0.8...master)

# v0.0.8 2013-06-19

* [feature] Add the following chain processors
  * `Substation::Processor::Evaluator`
  * `Substation::Processor::Pivot`
  * `Substation::Processor::Wrapper`

* [feature] Add `Substation::Environment` for registering processors by name

        env = Substation::Environment.build do
          register :authenticate, My::Authenticator # implemented by you
          register :authorize,    My::Authorizer    # implemented by you
          register :evaluate,     Substation::Processor::Evaluator
          register :call,         Substation::Processor::Pivot
          register :wrap,         Substation::Processor::Wrapper
        end

* [feature] Add a DSL for constructing `Substation::Chain` instances

        AUTHENTICATED = env.chain { authenticate }
        AUTHORIZED    = env.chain(AUTHENTICATED) { authorize }

        CREATE_PERSON = env.chain(AUTHORIZED) do
          evaluate Sanitizers::NEW_PERSON
          evaluate Validators::NEW_PERSON

          call Actions::CreatePerson

          wrap Presenters::Person
          wrap Views::Person
        end

[Compare v0.0.7..v0.0.8](https://github.com/snusnu/substation/compare/v0.0.7...v0.0.8)

# v0.0.7 2013-06-14

* [feature] Make `Substation::Response#request` part of the public API (snusnu)
* [feature] Introduce `Substation::Chain` to process an action as a chain of
            incoming handlers, followed by the pivot handler and some outgoing
            handlers.

[Compare v0.0.6..v0.0.7](https://github.com/snusnu/substation/compare/v0.0.6...v0.0.7)

# v0.0.6 2013-05-17

* [fixed] Fixed bug for actions configured with a const handler (snusnu)

[Compare v0.0.5..v0.0.6](https://github.com/snusnu/substation/compare/v0.0.5...v0.0.6)

# v0.0.5 2013-05-17

* [feature] Shorter action config when no observers are needed (snusnu)

        dispatcher = Substation::Dispatcher.coerce({
          :some_use_case => App::SomeUseCase
        }, env)

        dispatcher = Substation::Dispatcher.coerce({
          :some_use_case => Proc.new { |request| request.success(:data) }
        }, env)

[Compare v0.0.4..v0.0.5](https://github.com/snusnu/substation/compare/v0.0.4...v0.0.5)

# v0.0.4 2013-05-15

* [changed] Bump concord dependency to ~> 0.1.0 (snusnu)

  * concord generated attribute readers are now `protected` by default

[Compare v0.0.3..v0.0.4](https://github.com/snusnu/substation/compare/v0.0.3...v0.0.4)

# v0.0.3 2013-05-15

* [changed] Stop (deep) freezing objects coming from client code (snusnu)

[Compare v0.0.2..v0.0.3](https://github.com/snusnu/substation/compare/v0.0.2...v0.0.3)

# v0.0.2 2013-05-15

* [BREAKING CHANGE] Creating a dispatcher requires an application env (snusnu)

  * Changes `Substation::Dispatcher.coerce(config)` to `Substation::Dispatcher.coerce(config, env)`
  * Changes `Substation::Dispatcher#call(name, input, env)` to `Substation::Dispatcher#call(name, input)`

[Compare v0.0.1..v0.0.2](https://github.com/snusnu/substation/compare/v0.0.1...v0.0.2)

# v0.0.1 2013-05-14

First public release
