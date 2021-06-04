# frozen_string_literal: true
require 'pry'

module ActorSync
  module Adapters
    module Mixpanel

      class UnknownActionError < StandardError
        def message
          'action provided in options isn\'t legal'
        end
      end

      class DataMethodNotFoundError < StandardError
        def message
          'actor must define data_to_export_to_mixpanel'
        end
      end

      class User
        def initialize(distinct_id, tracker, data, action)
          @distinct_id = distinct_id
          @tracker = tracker
          @data = data
          @action = action
        end

        def call
          create if [:create, :update].include? @action
          destroy if @action == :destroy
        end

        def create
          @tracker.people.set(@distinct_id, @data)
        end

        def destroy
          @tracker.people.delete_user(@distinct_id)
        end
      end

      class Group 
        def initialize(group_key, group_id, tracker, data, action)
          @group_key = group_key
          @group_id = group_id
          @tracker = tracker
          @data = data
          @action = action
        end

        def call
          create if [:create, :update].include? @action
          destroy if @action == :destroy
        end

        def create
          @tracker.groups.set(@group_key, @group_id, @data)
        end

        def destroy
          @tracker.groups.delete_group(@group_key, @group_id)
        end
      end

      class << self

        def send(actor, options, config)
          @config = config
          action = retrieve_action options
          data = retrieve_data(actor)

          case 
          when !options[:group].nil?
            Group.new(actor.class.name, actor.id, tracker, data, action).call
          else # Default to user profiles.
            User.new(actor.id, tracker, data, action).call
          end
        end
  
        private
        
        def tracker
          @tracker ||= ::Mixpanel::Tracker.new(@config.mixpanel[:project_token])
        end
  
        def retrieve_data(actor)
          raise DataMethodNotFoundError unless actor.respond_to?(:data_to_export_to_mixpanel)
          actor.data_to_export_to_mixpanel
        end

        def retrieve_action(options)
          action = options[:callback_type]
          raise UnknownActionError unless %i(create update destroy).include?(action)
          action
        end
      end
    end
  end
end
