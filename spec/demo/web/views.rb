# encoding: utf-8

class Demo
  module Web

    module Views

      module Layout
        def page_title
          'substation demo'
        end
      end

      class Person < Presenter
        include Layout
      end

      class SanitizationError
        include Concord::Public.new(:error)
        include Layout
      end

      class InternalError
        include Concord::Public.new(:data)
      end
    end
  end
end
