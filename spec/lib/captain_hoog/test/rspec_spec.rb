require 'spec_helper'

describe 'Rspec support' do
  let(:foo) do
    <<-PLUGIN
      git.describe 'foo' do |hook|
        hook.helper :foo_helper do
          config.number
        end

        hook.test do
          foo_helper
          true
        end

        hook.message do
          'Fun'
        end
      end
    PLUGIN
  end

  let(:config) do
    {
      env: {
        suppress_headline: true
      },
      plugin: {
        foo: {
          number: 12
        }
      }
    }
  end

  with_plugin :foo, config: :config, silence: true do
    describe 'helpers' do
      it 'plugin has helper :foo_helper' do
        expect(plugin).to respond_to(:foo_helper)
      end

      describe ':foo_helper' do
        it 'returns configured number' do
          expect(plugin.foo_helper).to eq config[:plugin][:foo][:number]
        end
      end
    end

    describe 'plugin test' do
      it 'is true' do
        expect(plugin.result[:test]).to be true
      end
    end

    describe 'success message' do
      it 'prints out "Fun"' do
        expect(plugin.result[:message]).to eq 'Fun'
      end
    end
  end
end
