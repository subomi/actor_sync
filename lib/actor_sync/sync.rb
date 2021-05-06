# frozen_string_literal: true

class Sync
  def initialize(actor, destination)
    @actor = actor
    @destination = destination
  end

  def call
    sync_job = SyncJob.new(@actor, @destination)
    
    SyncWorker.perform_later(sync_job)
    adapter_klass = Adapters.get_adapter_klass(@destination)
    adapter = adapter_klass.new(@actor)

    adapter.send
  end
end
