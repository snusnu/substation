# encoding: utf-8

class Demo
  module Core

    class Input
      class Incomplete
        include Concord::Public.new(:session, :data)
      end
      class Accepted
        include Concord::Public.new(:actor, :data)
      end
    end
  end
end
