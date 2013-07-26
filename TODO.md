* Introduce `Response::Exception` to replace `Chain::FailureData`
* Support injecting a hash'ish (`#[]`) "action registry" object into
  `Dispatcher#initialize`.This will remove the need for the `Dispatcher::DSL`
  and the centralized dispatch table definition that comes with that.
  No explicit finalization of the action registry will be needed, since the
  dispatchers will be initialized with them. Something like that:

    ```ruby
    class Demo
      module Core
        @actions = {}

        def self.actions
          @actions
        end

        class Action

          # Could probably be turned into a module class
          # shipped with substation, that supports using
          # the appropriate registry object. This will be
          # useful when more than one substation application
          # is needed. It could be used like this:
          #
          # extend Substation::Action::Handler.new(Core.actions)
          #
          module Handler
            def register_as(name)
              Core.actions[name.to_sym] = self
            end
          end

          extend Handler

          class CreatePerson < self

            register_as :create_person

            def self.call(request)
              # ....
            end
          end
        end

        APP = Substation::Dispatcher.new(APP_ENV, Core.actions)
      end
    end
    ```

* Think about removing `Action` and providing an `Observable` module instead
