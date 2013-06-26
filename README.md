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

Think of `substation` as some sort of domain level request router. It assumes
that every usecase in your application has a name and is implemented in a dedicated
object that will be referred to as an *action*. The only protocol such actions must
support is `#call(request)`.

The contract for actions specifies that when invoked, they can
receive arbitrary input data which will be available in `request.input`.
Additionally, `request.env` contains an arbitrary object that
represents your application environment and will typically provide access
to useful things like a logger and probably some sort of storage engine
abstraction object.

The contract further specifies that every action must return an instance
of either `Substation::Response::Success` or
`Substation::Response::Failure`. Again, arbitrary data can be associated
with any kind of response, and will be available in `response.output`. To
indicate wether invoking the action was successful or not, you can use
`response.success?`. In addition to that, `response.request` contains
the request object used to invoke the action.

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
    include Equalizer.new(:relations)

    def initialize(relations)
      @relations = relations
    end

    def [](relation_name)
      Relation.new(relations[relation_name])
    end

    protected

    attr_reader :relations

    class Relation
      include Equalizer.new(:tuples)
      include Enumerable

      def initialize(tuples)
        @tuples = tuples
      end

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

      protected

      attr_reader :tuples
    end
  end

  module Models

    class Person
      include Equalizer.new(:id, :name)

      attr_reader :id
      attr_reader :name

      def initialize(attributes)
        @id, @name = attributes.values_at(:id, :name)
      end
    end
  end # module Models

  class Environment
    include Equalizer.new(:storage)

    attr_reader :storage

    def initialize(storage)
      @storage = storage
    end
  end

  class Storage
    include Equalizer.new(:db)
    include Models

    def initialize(db)
      @db = db
    end

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

    protected

    attr_reader :db
  end

  class App
    include Equalizer.new(:dispatcher)

    def initialize(dispatcher)
      @dispatcher = dispatcher
    end

    def call(name, input = nil)
      @dispatcher.call(name, input)
    end
  end

  # Base class for all actions
  #
  # @abstract
  class Action

    include AbstractType

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
    LogEvent  = Proc.new { |response| response }
    SendEmail = Proc.new { |response| response }
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

## Chains

In a typical application scenario, a few things need to happen before an
actual use case (an action) can be invoked. These things will often
include the following steps (probably in that order).

* Input data sanitization
* Authentication
* Authorization
* Input data validation

We only want to invoke our action if all those steps succeed. If any of
the above steps fails, we want to send back a response that provides
details about what exactly prevented us from further processing the
request. If authentication fails, why try to authorize. If authorization
fails, why try to sanitize. And so on.

If, however, all the above steps passed, we can

* Invoke the action

Oftentimes, at this point, we're not done just yet. We have invoked our
action and we probably got back some data, but we still need to turn it
into something the caller can easily consume. If you happen to develop a
web application for example, you'll probably want to render some HTML or
some JSON.

a) If you need to return HTML, you might

* Wrap the response data in some presenter object
* Wrap the presenter in some view object
* Use that view object to render an HTML template

b) If you need to return JSON, you might just

* Pass the response data to some serializer object and dump it to JSON

To allow chaining all those steps in a declarative way, substation
provides an object called `Substation::Chain`. Its contract is dead
simple:

1. `#call(Substation::Request) => Substation::Response`
2. `#result(Substation::Response) => Substation::Response`

You typically won't be calling `Substation::Chain#result` yourself, but
having it around, allows us to use chains in *incoming handlers*,
essentially nesting chains. This makes it possible to construct one
chain up until the pivot handler, and then reuse that same chain in one
usecase that takes the response and renders HTML, and in another that
renders JSON.

To construct a chain, you need to pass an enumerable of so called
handler objects to `Substation::Chain.new`. Handlers must support two
methods:

1. `#call(<Substation::Request, Substation::Response>) => Substation::Response`
2. `#result(Substation::Response) => <Substation::Request, Substation::Response>`

### Incoming handlers

All steps required *before* processing the action will potentially
produce a new, altered, `Substation::Request`. Therefore, the object
passed to `#call` must be an instance of `Substation::Request`.

Since `#call` must return a `Substation::Response` (because the chain
would halt and return that response in case calling its `#success?`
method would return `false`), we also need to implement `#result`
and have it return a `Substation::Request` instance that can be passed
on to the next handler.

The contract for incoming handlers therefore is:

1. `#call(Substation::Request) => Substation::Response`
2. `#result(Substation::Response) => Substation::Request`

By including the `Substation::Chain::Incoming` module into your handler
class, you'll get the following for free:

```ruby
def result(response)
  Request.new(response.env, response.output)
end
```

This shows that an incoming handler can alter the incoming request in any
way that it wants to, as long as it returns the new request input data in
`Substation::Response#output` returned from `#call`.

### The pivot handler

Pivot is just another fancy name for the action in the context of a
chain. It's also the point where all subsequent handlers have to further
process the `Substation::Response` returned from invoking the action.

The contract for the pivot handler therefore is:

1. `#call(Substation::Request) => Substation::Response`
2. `#result(Substation::Response) => Substation::Response`

By including the `Substation::Chain::Pivot` module into your handler
class, you'll get the following for free:

```ruby
def result(response)
  response
end
```

This reflects the fact that a pivot handler (since it's the one actually
producing the "raw" response, returns it unaltered.

### Outgoing handlers

All steps required *after* processing the action will potentially
produce a new, altered, `Substation::Response` instance to be returned.
Therefore the object passed to `#call` must be an instance of
`Substation::Response`. Since subsequent outgoing handlers might further
process the response, `#result` must be implemented so that it returns a
`Substation::Response` object that can be passed on to the next handler.

The contract for outgoing handlers therefore is:

1. `#call(Substation::Response) => Substation::Response`
2. `#result(Substation::Response) => Substation::Response`

By including the `Substation::Chain::Outgoing` module into your handler
class, you'll get the following for free:

```ruby
def result(response)
  response
end
```

This shows that an outgoing handler's `#call` can do anything with
the `Substation::Response#output` it received, as long as it makes
sure to return a new response with the new output properly set.

### Example

[substation-demo](https://github.com/snusnu/substation-demo) implements a
simple web application using `Substation::Chain`.

The demo implements a few of the above mentioned *incoming handlers*
for

* [Sanitization](https://github.com/snusnu/substation-demo/blob/master/demo/web/sanitizers.rb) using [ducktrap](https://github.com/mbj/ducktrap)
* [Validation](https://github.com/snusnu/substation-demo/blob/master/demo/validators.rb) using [vanguard](https://github.com/mbj/vanguard)

and some simple *outgoing handlers* for

* Wrapping response output in a
[presenter](https://github.com/snusnu/substation-demo/blob/master/demo/web/presenters.rb)
* [Serializing](https://github.com/snusnu/substation-demo/blob/master/demo/web/serializers.rb) response output to JSON

The
[handlers](https://github.com/snusnu/substation-demo/blob/master/demo/web/processors.rb)
are called *processors* in that app, and encapsulate the actual handler
performing the job. That's a common pattern, because you typically will
have to adapt to the interface your actual handlers provide.

Have a look at the base
[actions](https://github.com/snusnu/substation-demo/blob/master/demo/web/actions.rb)
that are then used to either produce
[HTML](https://github.com/snusnu/substation-demo/blob/master/demo/web/actions/html.rb)
or
[JSON](https://github.com/snusnu/substation-demo/blob/master/demo/web/actions/json.rb).

Finally it's all hooked up behind a few
[sinatra](https://github.com/sinatra/sinatra)
[routes](https://github.com/snusnu/substation-demo/blob/master/demo/web/routes.rb)

## Credits

* [snusnu](https://github.com/snusnu)
* [mbj](https://github.com/mbj)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Copyright

Copyright &copy; 2013 Martin Gamsjaeger (snusnu). See [LICENSE](LICENSE) for details.
