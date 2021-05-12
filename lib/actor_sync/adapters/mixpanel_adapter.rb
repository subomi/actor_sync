# frozen_string_literal: true

module ActorSync
  module Adapters
    class MixpanelAdapter
      def initialize(actor)
        @actor = actor
      end
  
      def send
        tracker = ::Mixpanel::Tracker.new(config.mixpanel[:project_token])
        tracker.people.set(@actor.id, data)
      end
  
      private
  
      # TODO: Log a warning when this method wasn't defined.
      def data
        @actor.data_to_export_to_mixpanel
      end

      def config
        Configuration
      end
    end
  end
end
