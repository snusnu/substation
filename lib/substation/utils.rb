module Substation

  # A collection of utility methods
  module Utils

    # Get the constant for the given FQN
    #
    # @param [#to_s] name
    #   the FQN denoting a constant
    #
    # @return [Class, nil]
    #
    # @api private
    def self.const_get(name)
      list = name.to_s.split("::")
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

    # Converts string keys into symbol keys
    #
    # @param [Hash<#to_sym, Object>] hash
    #   a hash with keys that respond to `#to_sym`
    #
    # @return [Hash<Symbol, Object>]
    #   a hash with symbol keys
    #
    # @api private
    def self.symbolize_keys(hash)
      hash.each_with_object({}) { |(key, value), normalized_hash|
        normalized_value = value.is_a?(Hash) ? symbolize_keys(value) : value
        normalized_hash[key.to_sym] = normalized_value
      }
    end

    # Coerce the given +handler+ object
    #
    # @param [Symbol, String, Proc] handler
    #   a name denoting a const that responds to `#call(object)`, or a proc
    #
    # @return [Class, Proc]
    #   the callable action handler
    #
    # @api private
    def self.coerce_callable(handler)
      case handler
      when Symbol, String
        Utils.const_get(handler)
      when Proc, Class, Chain
        handler
      else
        raise(ArgumentError)
      end
    end

  end # module Utils
end # module Substation
