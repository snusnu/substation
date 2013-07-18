# encoding: utf-8

class Demo
  module Web
    module Sanitizer

      NEW_PERSON = Ducktrap.build do
        primitive(Hash)
        hash_transform do
          fetch_key('name') do
            primitive(String)
            dump_key(:name)
          end
        end
        add(ID_TRAP)
        anima_load(Core::Models::Person)
      end
    end
  end
end
