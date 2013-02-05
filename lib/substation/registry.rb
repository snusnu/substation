module Substation

  class Registry

    def initialize
      @registry = Set.new
    end

    def register(action)
      @registry << action
    end

    def each
      return to_enum unless block_given?
      @registry.each { |action| yield(action) }
      self
    end

    def include?(action)
      @registry.include?(action)
    end
  end # class Registry
end # module Substation
