# frozen_string_literal: true

require 'active_support/core_ext/string'

module Adapters
  def get_adapter_klass(destination)
    klass = "Adapters::#{destination.camelize}"
    klass.constantize
  end
end
