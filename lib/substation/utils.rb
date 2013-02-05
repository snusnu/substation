module Substation
  module Utils

    def self.full_const_defined?(obj, name = nil)
      !!self.full_const_get(obj, name) rescue false
    end

    # Returns the value of the specified constant.
    #
    # @overload full_const_get(obj, name)
    #   Returns the value of the specified constant in +obj+.
    #   @param [Object] obj The root object used as origin.
    #   @param [String] name The name of the constant to get, e.g. "Merb::Router".
    #
    # @overload full_const_get(name)
    #   Returns the value of the fully-qualified constant.
    #   @param [String] name The name of the constant to get, e.g. "Merb::Router".
    #
    # @return [Object] The constant corresponding to +name+.
    #
    # @api semipublic
    def self.full_const_get(obj, name = nil)
      obj, name = ::Object, obj if name.nil?

      list = name.split("::")
      list.shift if Utils.blank?(list.first)
      list.each do |x|
        # This is required because const_get tries to look for constants in the
        # ancestor chain, but we only want constants that are HERE
        obj = obj.const_defined?(x) ? obj.const_get(x) : obj.const_missing(x)
      end
      obj
    end

    def self.namespace(const, boundary = nil)
      path   = const.name.split('::')
      return ::Object if path.size == 1
      idx = boundary ? path.index(boundary) - 1 : path.size - 2
      full_const_get(path[0..idx].join('::'))
    end

    # Determines whether the specified +value+ is blank.
    #
    # An object is blank if it's false, empty, or a whitespace string.
    # For example, "", "   ", +nil+, [], and {} are blank.
    #
    # @api semipublic
    def self.blank?(value)
      return value.blank? if value.respond_to?(:blank?)
      case value
      when ::NilClass, ::FalseClass
        true
      when ::TrueClass, ::Numeric
        false
      when ::Array, ::Hash
        value.empty?
      when ::String
        value !~ /\S/
      else
        value.nil? || (value.respond_to?(:empty?) && value.empty?)
      end
    end
  end # module Utils
end # module Substation
