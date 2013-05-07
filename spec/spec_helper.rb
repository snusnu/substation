require 'substation'
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

include Substation

RSpec.configure do |config|
end
