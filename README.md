# substation

[![Build Status](https://secure.travis-ci.org/snusnu/substation.png?branch=master)](http://travis-ci.org/snusnu/substation)
[![Dependency Status](https://gemnasium.com/snusnu/substation.png)](https://gemnasium.com/snusnu/substation)
[![Code Climate](https://codeclimate.com/github/snusnu/substation.png)](https://codeclimate.com/github/snusnu/substation)

`substation` can be thought of as a domain level request router. It assumes
that every usecase in your application has a name and is implemented in a dedicated
class that will be referred to as an *action* for the purposes of this
document. The only protocol such actions must support is `#call(request)`.

The contract for actions specifies that when invoked, actions can
receive arbitrary input data which will be available in `request.input`.
Additionally, `request.env` contains an arbitrary object that
represents your application environment and will typically provide access
to useful things like a logger or a storage engine abstraction.

The contract further specifies that every action must return an instance
of either `Substation::Response::Success` or
`Substation::Response::Failure`. Again, arbitrary data can be associated
with any kind of response, and will be available in `response.data`. In
addition to that, `response.success?` is available and will indicate
wether invoking the action was successful or not.

`Substation::Dispatcher` stores a mapping of action names to the actual
objects implementing the action. Clients can use
`Substation::Dispatcher#call(name, input, env)` to dispatch to any
registered action. For example, a web application could map an http
route to a specific action name and pass relevant http params on to the
action.

## Actions

Here's an example of a valid action.

```ruby
module App
  class SomeUseCase

    # Perform the usecase
    #
    # @param [Substation::Request] request
    #   the request passed to the registered action
    #
    # @return [Substation::Response]
    #   the response returned when calling the action
    #
    # @api private
    def self.call(request)
      data = perform_work
      if data
        request.success(data)
      else
        request.error("Something went wrong")
      end
    end
  end
end
```

It is up to you how to implement the action. Another way of writing an
action could involve providing an application specific baseclass for all
your actions, which provides access to methods you frequently use within
any specific action.

```ruby
module App

  # Base class for all actions
  #
  # @abstract
  class Action

    # Perform the usecase
    #
    # @param [Substation::Request] request
    #   the request passed to the registered action
    #
    # @return [Substation::Response]
    #   the response returned when calling the action
    #
    # @api private
    def self.call(request)
      new(request).call
    end

    def initialize(request)
      @request = request
      @env     = @request.env
    end

    def call
      raise NotImplementedError, "#{self.class}##{__method__} must be implemented"
    end

    private

    def success(data)
      @request.success(data)
    end

    def error(data)
      @request.error(data)
    end
  end

  class SomeUseCase < Action

    def call
      data = perform_work
      if data
        success(data)
      else
        error("Something went wrong")
      end
    end
  end
end
```

## Observers

Sometimes, additional code needs to run wether your action was
successful or not. Observers provide you with a place for that code.
Again, the contract for observers is very simple: all they need to
implement is `call(response)` and `substation` will make sure that the
`response` param will be the response returned from invoking your
action.

It is therefore possible to dispatch to different observers based on
wether the action was successful or not by utilizing
`response.success?`. By accepting a `response` object, observers also
have access to the original `input` and `env` the action was invoked
with, as well as the `output` that the action produced. These objects
are made available via `response.input`, `response.env` and
`response.output`.

Here's an example of a simple observer:

```ruby
module App
  class SomeUseCaseObserver
    def self.call(response)
      # your code here
    end
  end
end
```

A more involved observer could dispatch based on the success of the
invoked action:

```ruby
module App
  class SomeUseCaseObserver
    def self.call(response)
      klass = response.success? ? Success : Failure
      klass.new(response).call
    end

    def initialize(response)
      @response = response
    end

    class Success < self
      def call
        # your code here
      end
    end

    class Failure < self
      def call
        # your code here
      end
    end
  end
end
```

## Configuration

Since an application will most likely involve more than one usecase, we
need a way to inform `substation` about all the usecases it should handle.
For this purpose, we can instantiate a `Substation::Dispatcher` and hand
it a configuration hash that describes the various actions by giving
them a name, a class that's responsible for implementing the actual
usecase, and a list of `0..n` observers that should be invoked depending
on the action response.

An example configuration for an action without any observers:

```ruby
dispatcher = Substation::Dispatcher.coerce({
  'some_use_case' => { 'action' => 'App::SomeUseCase' }
})
```

An example configuration for an action with one observer:

```ruby
dispatcher = Substation::Dispatcher.coerce({
  'some_use_case' => {
    'action'   => 'App::SomeUseCase',
    'observer' => 'App::SomeUseCaseObserver'
  }
})
```

An example configuration for an action with multiple observers:

```ruby
dispatcher = Substation::Dispatcher.coerce({
  'some_use_case' => {
    'action'   => 'App::SomeUseCase',
    'observer' => [
      'App::SomeUseCaseObserver',
      'App::AnotherObserver'
    ]
  }
})
```

## Application environments

In order to provide your actions with objects typically needed during
the course of performing a usecase (like a logger or a storage engine
abstraction), you can encapsulate these objects within an application
specific environment object, and send that along to every action.

Here's a simple example with an environment that encapsulates a logger,
an artificial storage abstraction object and the dispatcher itself.

The example builds on top of the application specific action baseclass
shown above:

```ruby
module App
  class Environment
    attr_reader :storage
    attr_reader :dispatcher
    attr_reader :logger

    def initialize(storage, dispatcher, logger)
      @storage    = storage
      @dispatcher = dispatcher
      @logger     = logger
    end
  end

  class Action
    # ...
    # code from above example
    # ...

    def db
      @env.storage
    end
  end

  class SomeUseCase < Action

    def initialize(request)
      super
      @person = request.input
    end

    def call
      if person = db.save_person(@person)
        success(person)
      else
        error("Something went wrong")
      end
    end
  end
end

dispatcher = Substation::Dispatcher.coerce({
  'some_use_case' => { 'action' => 'App::SomeUseCase' }
})

storage = App::Storage.new # some storage abstraction
env     = App::Environment.new(storage, dispatcher, Logger.new($stdout))

# :some_input is no person, db.save_person will fail
response = dispatcher.call(:some_use_case, :some_input, env)
response.success? # => false
```
