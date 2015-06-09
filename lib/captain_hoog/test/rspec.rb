module CaptainHoog
  module Test
    module RSpec
      module TestCase

        attr_reader :plugin

        def with_plugin(plugin_name, config: nil, silence: false)
          before do
            cfg = config ? self.send(config) : {}
            cfg.merge!(env: { suppress_headline: silence }) if silence
            build_sandbox(plugin_name, cfg)
          end
          context "with plugin #{plugin_name}" do
            yield if block_given?
          end
        end

        private

        def build_sandbox(plugin_name, cfg)
          plugin_code  = self.send(plugin_name)
          sandbox      = CaptainHoog::Test::Sandbox.new(plugin_code, cfg)
          sandbox.run
          @plugin      = sandbox.plugin
        end

      end
    end
  end
end

RSpec.configure do |config|
  config.include CaptainHoog::Test::RSpec::TestCase
  config.extend CaptainHoog::Test::RSpec::TestCase
end
