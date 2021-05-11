# frozen_string_literal: true

module ActorSync
  module Adapters
    class Mixpanel
      def initialize(actor)
        @actor = actor
      end
  
      def send
        tracker = Mixpanel::Tracker.new(Configuration.mixpanel[:token])
        tracker.people.set(@actor.id, data)
      end
  
      private
  
      def data
        @actor.data_to_mixpanel
      end
    end
  end
end
