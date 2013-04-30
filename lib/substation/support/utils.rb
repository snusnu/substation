module Substation
  module Utils

    # Get the constant for the given FQN
    #
    # @param [String] name
    #   the FQN denoting a constant
    #
    # @return [Class, nil]
    #
    # @api private
    def self.const_get(name)
      list = name.split("::")
      list.shift if list.first.empty?
      obj = Object
      list.each do |const|
        # This is required because const_get tries to look for constants in the
        # ancestor chain, but we only want constants that are HERE
        obj =
          if obj.const_defined?(const)
            obj.const_get(const)
          else
            obj.const_missing(const)
          end
      end
      obj
    end

  end # module Utils
end # module Substation
