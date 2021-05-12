# frozen_string_literal: true

require 'mixpanel-ruby'
require 'zeitwerk'
require 'listen'

GEM_PATH = File.expand_path('..', __dir__)

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.setup

module ActorSync
  class Error < StandardError; end

  def self.included(base)
    base.extend ClassMethods
  end

  def self.configure 
    yield Configuration if block_given?
  end

  module ClassMethods
    # Generate an instance method to be passed to after_commit
    # Call class method after_commit & pass earlier defined instance method.
    def actor_sync(destination, opts = {})
      method_name = "export_to_#{destination}"

      instance_eval do
        define_method method_name  do
          pp "sending to third party"
          Sync.new(self, destination, opts).call
        end
      end

      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        after_commit :#{method_name}
      METHODS
    end
  end
end

Listen.to("#{GEM_PATH}/lib") do
  loader.reload
end.start
