# encoding: utf-8

class Demo
  module Core
    module Models

      class Person
        include Anima.new(:id, :name)
      end

    end
  end
end
