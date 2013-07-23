# encoding: utf-8

module Substation
  class Response

    # A successful {Response}
    class Success < self
      include API::Success
    end # class Success
  end # class Response
end # module Substation
