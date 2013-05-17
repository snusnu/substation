# substation

[![Gem Version](https://badge.fury.io/rb/substation.png)][gem]
[![Build Status](https://secure.travis-ci.org/snusnu/substation.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/snusnu/substation.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/snusnu/substation.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/snusnu/substation/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/substation
[travis]: https://travis-ci.org/snusnu/substation
[gemnasium]: https://gemnasium.com/snusnu/substation
[codeclimate]: https://codeclimate.com/github/snusnu/substation
[coveralls]: https://coveralls.io/r/snusnu/substation

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
objects implementing the action, as well as the application environment.
Clients can use `Substation::Dispatcher#call(name, input)` to dispatch to
any registered action. For example, a web application could map an http
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
on the action response. In addition to that, we must pass an instance of
the application's environment. More about application environments can
be found in the next paragraph.

An example configuration for an action without any observers:

```ruby
# short form
dispatcher = Substation::Dispatcher.coerce({
  'some_use_case' => 'App::SomeUseCase'
}, env)

# long form
dispatcher = Substation::Dispatcher.coerce({
  'some_use_case' => { 'action' => 'App::SomeUseCase' }
}, env)
```

An example configuration for an action with one observer:

```ruby
dispatcher = Substation::Dispatcher.coerce({
  'some_use_case' => {
    'action'   => 'App::SomeUseCase',
    'observer' => 'App::SomeUseCaseObserver'
  }
}, env)
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
}, env)
```

The above configuration examples are tailored towards being read from a
(yaml) config file and therefore accept strings as keys and values. It's
also possible to use symbols as keys (and values). Values correspond to
action or observer "handlers" and can also be given as either constants,
symbols, or procs. In any case, handlers must respond to `call(object)`.

An example configuration using symbol keys and constants for handlers:

```ruby
# short form (without observers)
dispatcher = Substation::Dispatcher.coerce({
  :some_use_case => App::SomeUseCase
}, env)

# long form
dispatcher = Substation::Dispatcher.coerce({
  :some_use_case => {
    :action   => App::SomeUseCase,
    :observer => App::SomeUseCaseObserver
  }
}, env)
```

An example configuration using symbol keys and procs for handlers:

```ruby
# short form (without observers)
dispatcher = Substation::Dispatcher.coerce({
  :some_use_case => Proc.new { |request| request.success(:data) }
}, env)

dispatcher = Substation::Dispatcher.coerce({
  :some_use_case => {
    :action   => Proc.new { |request| request.success(:foo) },
    :observer => Proc.new { |response| do_something }
  }
}, env)
```

## Application environments

In order to provide your actions with objects typically needed during
the course of performing a usecase (like a logger or a storage engine
abstraction), you can encapsulate these objects within an application
specific environment object, and send that along to every action.

Here's a complete example with an environment that encapsulates a very
primitive storage abstraction object, one simple business entity, and a
few simple actions.

```ruby
module App

  class Database
    include Concord.new(:relations)

    def [](relation_name)
      Relation.new(relations[relation_name])
    end

    class Relation
      include Concord.new(:tuples)
      include Enumerable

      def each(&block)
        return to_enum unless block_given?
        tuples.each(&block)
        self
      end

      def all
        tuples
      end

      def insert(tuple)
        self.class.new(tuples + [tuple])
      end
    end
  end

  module Models

    class Person
      include Concord.new(:attributes)

      def id
        attributes[:id]
      end

      def name
        attributes[:name]
      end
    end
  end # module Models

  class Environment
    include Concord.new(:storage)
    include Adamantium::Flat

    attr_reader :storage
  end

  class Storage
    include Concord.new(:db)
    include Adamantium::Flat

    include Models

    def list_people
      db[:people].all.map { |tuple| Person.new(tuple) }
    end

    def load_person(id)
      Person.new(db[:people].select { |tuple| tuple[:id] == id }.first)
    end

    def create_person(person)
      relation = db[:people].insert(:id => person.id, :name => person.name)
      relation.map { |tuple| Person.new(tuple) }
    end
  end

  class App
    include Concord.new(:dispatcher)
    include Adamantium::Flat

    def call(name, input = nil)
      dispatcher.call(name, input)
    end
  end

  # Base class for all actions
  #
  # @abstract
  class Action

    include AbstractType
    include Adamantium::Flat

    def self.call(request)
      new(request).call
    end

    def initialize(request)
      @request = request
      @env     = @request.env
      @input   = @request.input
    end

    abstract_method :call

    private

    attr_reader :request
    attr_reader :env
    attr_reader :input

    def db
      @env.storage
    end

    def success(data)
      @request.success(data)
    end

    def error(data)
      @request.error(data)
    end
  end

  module Actions
    class ListPeople < Action

      def call
        success(db.list_people)
      end
    end

    class LoadPerson < Action
      def initialize(request)
        super
        @id = input
      end

      def call
        success(db.load_person(@id))
      end
    end

    class CreatePerson < Action

      def initialize(request)
        super
        @person = input
      end

      def call
        success(db.create_person(@person))
      end
    end

  end # module Actions

  module Observers
    LogEvent  = Class.new { def self.call(response); end }
    SendEmail = Class.new { def self.call(response); end }
  end

  DB = Database.new({
    :people => [{
      :id   => 1,
      :name => 'John'
    }]
  })

  actions = {
    :list_people   => Actions::ListPeople,
    :load_person   => Actions::LoadPerson,
    :create_person => {
      :action   => Actions::CreatePerson,
      :observer => [
        Observers::LogEvent,
        Observers::SendEmail
      ]
    }
  }

  storage    = Storage.new(DB)
  env        = Environment.new(storage)
  dispatcher = Substation::Dispatcher.coerce(actions, env)

  APP = App.new(dispatcher)
end

response = App::APP.call(:list_companies)
response.success? # => true
response.output   # => [#<App::Models::Person attributes={:id=>1, :name=>"John"}>]
```

## Credits

* [snusnu](https://github.com/snusnu)
* [mbj](https://github.com/mbj)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Copyright

Copyright &copy; 2013 Martin Gamsjaeger (snusnu). See [LICENSE](LICENSE) for details.
