require 'substation'
require 'devtools/spec_helper'

module Spec

  def self.response_data
    :data
  end

  def self.success_response
    Substation::Action::Response::Success.new(response_data)
  end

  def self.failure_response
    Substation::Action::Response::Failure.new(response_data)
  end

  class Observer
  end

  class Action < Substation::Action
    class Success < self
      def perform
        pass(Spec.response_data)
      end
    end

    class Failure < self
      def perform
        fail(Spec.response_data)
      end
    end
  end

  class Observer
    class Success
      def self.call(event)
      end
    end

    class Failure
      def self.call(event)
      end
    end
  end
end

include Substation

RSpec.configure do |config|
end
