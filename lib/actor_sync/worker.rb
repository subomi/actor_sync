module ActorSync
  class Worker < ::ApplicationJob
    queue_as :default

    def perform(actor_klass, actor_id, destination)
      actor = actor_klass.find(actor_id)
      adapter_klass = Adapters.get_adapter_klass(destination)
      adapter = adapter_klass.new(actor)

      adapter.send
    end
  end
end
