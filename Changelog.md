# v0.0.5 2013-05-17

* [feature] Shorter action config when no observers are needed (snusnu)

```ruby
dispatcher = Substation::Dispatcher.coerce({
  :some_use_case => App::SomeUseCase
}, env)

dispatcher = Substation::Dispatcher.coerce({
  :some_use_case => Proc.new { |request| request.success(:data) }
}, env)
```

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
