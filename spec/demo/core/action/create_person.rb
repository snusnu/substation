# encoding: utf-8

class Demo
  module Core
    class Action

      class CreatePerson < self

        def initialize(*)
          super
          @person = input.data
        end

        def call
          name = @person.name
          if name == 'error'
            error(@person)
          elsif name == 'exception'
            raise RuntimeError
          else
            success(@person)
          end
        end
      end

    end
  end
end
