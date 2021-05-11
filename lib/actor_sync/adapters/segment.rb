# frozen_string_literal: true

module ActorSync
  module Adapters
    class Segment
      def initialize(actor)
        @actor = actor
      end
  
      def send
        analytics = Segment::Analytics.new(write_key: ENV['SEGMENT_WRITE_KEY'])
        analytics.identify(@actor.id, traits: data)
      end
  
      private
  
      def data
        @actor.data_to_segment
      end
    end
  end
end
