# frozen_string_literal: true

class Sync
  def initialize(actor, destination)
    @actor = actor
    @destination = destination
  end

  def call
    adapter_klass = Adapters.get_adapter(@destination)
    adapter = adapter_klass.new(@actor)

    adapter.send
  end
end
