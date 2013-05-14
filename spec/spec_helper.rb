require 'devtools/spec_helper'

module Spec

  def self.response_data
    :data
  end

  class Observer
    def self.call(response)
    end
  end

  class Action
    class Success
      def self.call(request)
        request.success(Spec.response_data)
      end
    end

    class Failure
      def self.call(request)
        request.error(Spec.response_data)
      end
    end
  end

end

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name     'spec:unit'
    add_filter       'config'
    add_filter       'spec'
    minimum_coverage 100
  end
end

require 'substation'

include Substation

RSpec.configure do |config|
end
