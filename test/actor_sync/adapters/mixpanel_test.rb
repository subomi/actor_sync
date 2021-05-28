require 'test_helper'

class User
end

class Company
end

module ActorSync
  class MixpanelTest < Minitest::Test
    def setup
      @actor = User.new 
      @group = Company.new
      @module_object = Adapters::Mixpanel
      @config = Object.new
    end
  
    def test_send_method_raises_when_actor_has_no_data_method_defined
      opts = { callback_type: %i(create update destroy).sample }
      error = assert_raises(Adapters::Mixpanel::DataMethodNotFoundError) do
        @module_object.send(@actor, opts, @config)
      end
      assert_equal 'actor must define data_to_export_to_mixpanel', error.message
    end
  
    def test_send_method_raises_when_unknown_action_is_provided
      opts = { callback_type: :xyz }
      error = assert_raises(Adapters::Mixpanel::UnknownActionError) do
        @module_object.send(@actor, opts, @config)
      end
      assert_equal 'action provided in options isn\'t legal', error.message
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_create_action_on_user
      opts = { callback_type: :create }

      def @actor.data_to_export_to_mixpanel; {} end
      def @actor.id; '123' end
      def @config.mixpanel; { project_token: '123abc' } end

      stub_request(:post, 'https://api.mixpanel.com/engage')

      @module_object.send(@actor, opts, @config)
      assert_requested :post, "https://api.mixpanel.com/engage"
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_update_action_on_user
      opts = { callback_type: :update }

      def @actor.data_to_export_to_mixpanel; {} end
      def @actor.id; '123' end
      def @config.mixpanel; { project_token: '123abc' } end

      stub_request(:post, 'https://api.mixpanel.com/engage')

      @module_object.send(@actor, opts, @config)
      assert_requested :post, "https://api.mixpanel.com/engage"
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_delete_action_on_user
      opts = { callback_type: :destroy }

      def @actor.data_to_export_to_mixpanel; {} end
      def @actor.id; '123' end
      def @config.mixpanel; { project_token: '123abc' } end

      stub_request(:post, 'https://api.mixpanel.com/engage')

      @module_object.send(@actor, opts, @config)
      assert_requested :post, "https://api.mixpanel.com/engage"
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_create_action_on_group
      opts = { callback_type: :create, group: true }

      def @group.data_to_export_to_mixpanel; {} end
      def @group.id; '456' end
      def @config.mixpanel; { project_token: '123abc' } end

      stub_request(:post, 'https://api.mixpanel.com/groups')
      
      @module_object.send(@group, opts, @config)
      assert_requested :post, 'https://api.mixpanel.com/groups'
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_update_action_on_group
      opts = { callback_type: :update, group: true }

      def @group.data_to_export_to_mixpanel; {} end
      def @group.id; '456' end
      def @config.mixpanel; { project_token: '123abc' } end

      stub_request(:post, 'https://api.mixpanel.com/groups')
      
      @module_object.send(@group, opts, @config)
      assert_requested :post, 'https://api.mixpanel.com/groups'
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_delete_action_on_group
      opts = { callback_type: :destroy, group: true }

      def @group.data_to_export_to_mixpanel; {} end
      def @group.id; '456' end
      def @config.mixpanel; { project_token: '123abc' } end

      stub_request(:post, 'https://api.mixpanel.com/groups')
      
      @module_object.send(@group, opts, @config)
      assert_requested :post, 'https://api.mixpanel.com/groups'
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_create_action_on_lookup
      skip 'coming soon'
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_update_action_on_lookup
      skip 'coming soon'
    end
  
    def test_send_method_calls_appropriate_endpoint_with_correct_params_on_delete_action_on_lookup
      skip 'coming soon'
    end
  
    class MixpanelUserTest < Minitest::Test
    end
  
    class MixpanelGroupUserTest < Minitest::Test
    end
  end
end
