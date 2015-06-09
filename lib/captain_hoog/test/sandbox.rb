module CaptainHoog
  module Test
    class Sandbox
      attr_accessor :configuration

      attr_reader :plugin

      module FakePlugin

        attr_reader :fake_plugin

        def fake(with_plugin: nil, config: {}, eval_plugin: :false)
          setup_env(config)
          self.instance_variable_set(:@raw_plugin, with_plugin)
          self.class.send(:define_method, :available_plugins, fake_code)
          self.plugins_eval if eval_plugin
        end

        module_function

        def fake_code
          proc do
            env = prepare_env
            @fake_plugin = CaptainHoog::Plugin.new(@raw_plugin, env)
            @fake_plugin.eval_plugin
            [@fake_plugin]
          end
        end

        def setup_env(configuration)
          configuration.keys.each do |key|
            self.send("#{key}_configuration", configuration)
          end
        end

        def env_configuration(configuration)
          suppress_headline = configuration[:env].fetch(:suppress_headline, false)
          self.class.suppress_headline = suppress_headline
        end

        def plugin_configuration(configuration)
          self.class.plugins_conf = CaptainHoog::Struct.new(configuration[:plugin])
        end

        def method_missing(meth_name, *args, &block)
          super unless meth_name.include?('_configuration')
        end
      end

      def initialize(raw_plugin, config = {})
        @raw_plugin    = raw_plugin
        @configuration = config
        init_plugin
      end

      def run
        @plugin = @pre_git.fake_plugin
        mod = Module.new do
          def result
            eigenplugin = self.send(:eigenplugin)
            git         = eigenplugin.instance_variable_get(:@git)
            { test: git.instance_variable_get(:@test_result) }
          end
        end
        @plugin.extend(mod)
      end

      private

      def init_plugin
        @pre_git = CaptainHoog::PreGit.new
        @pre_git.extend(CaptainHoog::Test::Sandbox::FakePlugin)
        @pre_git.fake(with_plugin: @raw_plugin, config: configuration)
        @pre_git.plugins_eval
      end

    end
  end
end
