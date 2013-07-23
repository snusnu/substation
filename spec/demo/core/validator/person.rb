# encoding: utf-8

class Demo
  module Core
    module Validator

      NEW_PERSON = Vanguard::Validator.build do
        validates_presence_of :name
        validates_length_of :name, :length => 3..20
      end
    end
  end
end
