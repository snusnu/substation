# v0.0.2 2013-05-15

* [BREAKING CHANGE] Creating a dispatcher requires an application env (snusnu)

  * Changes `Substation::Dispatcher.coerce(config)` to `Substation::Dispatcher.coerce(config, env)`
  * Changes `Substation::Dispatcher#call(name, input, env)` to `Substation::Dispatcher#call(name, input)`

[Compare v0.0.1..v0.0.2](https://github.com/snusnu/substation/compare/v0.0.1...v0.0.2)

# v0.0.1 2013-05-14

First public release
