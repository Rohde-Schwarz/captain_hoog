require 'spec_helper'

describe CaptainHoog::Test::Sandbox do
  let(:config) do
    {
      env: {
        suppress_headline: true
      }
    }
  end
  describe 'methods' do
    let(:null_plugin) do
      <<-PLUGIN
        git.describe 'null' do |hook|
          hook.run {}
        end
      PLUGIN
    end

    subject do
      described_class.new(null_plugin, config)
    end

    it 'provides #run' do
      expect(subject).to respond_to(:run)
    end

    it 'provides #configuration' do
      expect(subject).to respond_to(:configuration)
    end

    it 'provides #plugin' do
      expect(subject).to respond_to(:plugin)
    end
  end

  describe '#run' do
    context 'a plugin given as String' do

      let(:plugin) do
        <<-PLUGIN
          git.describe 'foo' do |hook|
            hook.helper :foo_helper do
              config.number
            end

            hook.test do
              foo_helper
              true
            end
          end
        PLUGIN
      end

      let(:sandbox) do
        plugins_config = {
          plugin: {
            foo: {
              number: 12
            }
          }
        }
        cfg = config.merge(plugins_config)
        CaptainHoog::Test::Sandbox.new(plugin, cfg)
      end

      before do
        sandbox.run
      end

      it 'assigns evaluated plugin to #plugin' do
        expect(sandbox.plugin).to_not be nil
        expect(sandbox.plugin).to respond_to(:foo_helper)
        expect(sandbox.plugin.foo_helper).to eq 12
      end

      describe "#plugin" do
        it 'provides #result' do
          expect(sandbox.plugin).to respond_to(:result)
        end

        it 'provides access to helper' do
          expect(sandbox.plugin.foo_helper).to eq 12
        end

        describe '#result' do
          it 'has :test key' do
            expect(sandbox.plugin.result).to have_key(:test)
          end
        end
      end
    end

    context 'a plugin given as file path', :skip do

    end

    context 'a plugin given as lambda', :skip do

    end
  end
end
