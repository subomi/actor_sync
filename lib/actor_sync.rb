# frozen_string_literal: true

require 'mixpanel-ruby'
require 'zeitwerk'

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
      callback_types = %i(create update destroy)

      callback_types.each do |callback_name|
        method_name = "export_to_#{destination}_on_#{callback_name}"

        instance_eval do
          define_method method_name  do
            opts[:callback_type] = callback_name
            Sync.new(self, destination, opts).call
          end
        end

        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          after_commit :#{method_name}, on: :#{callback_name}
        METHODS
      end
    end
  end
end
