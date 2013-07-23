# encoding: utf-8

class Demo
  module Web
    class Presenter

      class Person < self

        def name
          "Presenting: #{super}"
        end

        class Collection < Presenter::Collection
          member(Person)
        end
      end
    end
  end
end
