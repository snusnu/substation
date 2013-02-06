module Substation

  # TODO make this class immutable or implement finalization
  #
  class Registry

    include Enumerable

    def initialize(entries = Set.new)
      @entries = entries
    end

    def register(action)
      @entries << action
      self
    end

    def each
      return to_enum unless block_given?
      @entries.each { |action| yield(action) }
      self
    end

    def include?(action)
      @entries.include?(action)
    end

    def size
      @entries.size
    end
  end # class Registry
end # module Substation
