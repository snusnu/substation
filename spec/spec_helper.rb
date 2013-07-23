# encoding: utf-8

require 'devtools/spec_helper'

require 'concord' # makes spec setup easier

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

  class Processor
    include Substation::Processor::Incoming
    include Substation::Processor::Call::Incoming
    attr_reader :name
  end

  class Presenter
    include Concord.new(:data)
  end

  class Transformer
    def self.call(response)
      :transformed
    end
  end

  module Handler

    class Evaluator
      class Result

        include Concord::Public.new(:output)

        class Success < self
          def success?
            true
          end
        end

        class Failure < self
          def success?
            false
          end
        end
      end

      def self.call(data)
        new.call(data)
      end

      def call(data)
        if data == :success
          Result::Success.new(data)
        else
          Result::Failure.new(:failure)
        end
      end
    end

    class Pivot
      def call(request)
        request.success(request.input)
      end
    end

  end

  FAKE_ENV     = Object.new
  FAKE_HANDLER = Object.new

  FAKE_CONFIG = Substation::Processor::Config.new(
    FAKE_HANDLER,
    Substation::Chain::EMPTY,
    Substation::Processor::Executor::NULL
  )

  FAKE_PROCESSOR = Processor.new(:test, FAKE_CONFIG)

end

include Substation

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end
end
