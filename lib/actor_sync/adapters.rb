# frozen_string_literal: true

require 'active_support/core_ext/string'

module ActorSync
  module Adapters
    class << self
      def get_adapter_klass(destination)
        klass = "ActorSync::Adapters::#{destination.to_s.camelize}Adapter"
        klass.constantize
      end
    end
  end
end
