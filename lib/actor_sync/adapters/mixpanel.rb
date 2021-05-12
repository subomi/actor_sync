# frozen_string_literal: true

module ActorSync
  module Adapters
    class Mixpanel
      def initialize(actor, options)
        @actor = actor
        @options = options
        @tracker = tracker
      end
  
      def send
        case 
        when !@options[:user_profile].nil?
          @tracker.people.set(@actor.id, data)
        when !@options[:group_profile].nil?
          @tracker.groups.set(@actor.class.name, @actor.id, data)
        else # Default to user profiles.
          @tracker.people.set(@actor.id, data)
        end
      end
  
      private
      
      def tracker
        @tracker ||= ::Mixpanel::Tracker.new(config.mixpanel[:project_token])
      end
  
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
