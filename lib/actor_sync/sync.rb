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
        Worker.perform_later(@actor.class, @actor.id, @destination, @options)
        return
      end
    end
  
    private 
    
    def config
      Configuration
    end
  end
end
