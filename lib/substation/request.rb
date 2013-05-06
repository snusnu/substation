module Substation

  # Encapsulates an actor and a request model instance
  class Request
    include Concord.new(:actor, :data)
    include Adamantium
  end

end
