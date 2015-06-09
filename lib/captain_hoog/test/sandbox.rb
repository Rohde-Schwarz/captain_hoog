module CaptainHoog
  module Test
    class Sandbox
      attr_accessor :configuration

      attr_reader :plugin

      module FakePlugin
        def self.included(base)
          base.class_eval <<-RUBY, __FILE__,__LINE__ + 1

            def available_plugins
              Array(#{@plugin})
            end
          RUBY
        end

        def self.faker(opts={})
          @plugin = opts[:plugin]
          self
        end

      end

      def initialize(raw_plugin, config = {})
        @raw_plugin    = raw_plugin
        @configuration = config
        init_plugin
      end

      def run
        @plugin = @pre_git.available_plugins.first
      end

      private

      def init_plugin
        if configuration.key?(:env)
          suppress_headline = configuration[:env].fetch(:suppress_headline, false)
          CaptainHoog::PreGit.suppress_headline = suppress_headline
        end
        @pre_git = CaptainHoog::PreGit.new
        code = proc do
          env = prepare_env
          foo = CaptainHoog::Plugin.new(@raw_plugin, env).eval_plugin
          [foo]
        end
        @pre_git.instance_variable_set(:@raw_plugin, @raw_plugin)
        @pre_git.class.send(:define_method, :available_plugins, code)
        @pre_git.plugins_eval
      end

      def transformed_plugin
        env = @pre_git.send(:prepare_env)
        CaptainHoog::Plugin.new(@raw_plugin, env)
      end

    end
  end
end
