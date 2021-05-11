# frozen_string_literal: true

module ActorSync
  class Sync
    def initialize(actor, destination, opts = {})
      @actor = actor
      @destination = destination
      @options = opts
    end
  
    def call
      if config.sync
        Worker.perform_later(@actor.id, @destination)
        return
      end
    end
  
    private 
    
    def config
      Configuration
    end
  end
end
