# encoding: utf-8

module Substation
  class Response

    # An errorneous {Response}
    class Failure < self
      include API::Failure
    end # class Failure
  end # class Response
end # module Substation
