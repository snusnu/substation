# encoding: utf-8

class Demo
  module Domain
    module DTO

      NEW_PERSON_VALIDATOR = Vanguard::Validator.build do
        validates_presence_of :name
        validates_length_of :name, :length => 3..20
      end

      class Person
        include Anima.new(:id, :name)
      end

    end
  end
end
