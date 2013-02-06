module Substation

  # TODO make this class immutable or implement finalization
  #
  class Registry

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
  end # class Registry
end # module Substation
