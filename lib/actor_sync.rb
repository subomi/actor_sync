# frozen_string_literal: true

require 'zeitwerk'
require 'listen'

GEM_PATH = File.expand_path('..', __dir__)

module ActorSync
  class Error < StandardError; end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def after_commit(args)
      pp args
    end

    # Generate method to be passed to after_commit
    # Define after_commit & pass earlier defined method.
    def actor_sync(destination)
      method_name = "export_to_#{destination}"

      class_eval do
        define_method method_name do
          Sync.new(self, destination).call
        end
      end

      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        after_commit :#{method_name}
      METHODS
    end
  end
end

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.setup

Listen.to("#{GEM_PATH}/lib") do
  loader.reload
end.start
