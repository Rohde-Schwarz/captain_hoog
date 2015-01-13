require 'spec_helper'

describe CaptainHoog::Plugin do

  let(:code) do
    <<-CODE

    git do |pre|
      pre.helper :test_helper do
        env.variable
      end

      pre.test do
        false
      end

      pre.message do
        "Test failed."
      end
    end

    CODE
  end

  let(:env) do
    env = CaptainHoog::Env.new
    env[:variable] = 12
    env
  end

  let(:plugin) do
    CaptainHoog::Plugin.new(code, env)
  end

  it "provides access to the DSL" do
    expect(plugin).to respond_to(:git)
  end

  it "provides access to the env" do
    expect(plugin).to respond_to(:env)
  end

  describe "#initialize" do

    it "prepares git" do
      expect(plugin.instance_variable_get(:@git)).to_not be nil
    end

    it "assigns the plugin environment" do
      expect(plugin.instance_variable_get(:@env)).to \
        be_instance_of(CaptainHoog::Env)
    end

    it "assigns the plugin code" do
      expect(plugin.instance_variable_get(:@code)).to eq code
    end
  end

  context "evaluating a plugin" do

    it "provides a #eval_plugin method" do
      expect(plugin).to respond_to(:eval_plugin)
    end

    describe "#eval_plugin" do

      it "returns a Hash" do
        expect(plugin.eval_plugin).to be_instance_of(Hash)
      end

      describe "the returning hash" do

        it "includes the test result at the :result key" do
          expect(plugin.eval_plugin).to have_key(:result)
          expect(plugin.eval_plugin[:result]).to be false
        end

        it "includes the test failure message at the :message key" do
          expect(plugin.eval_plugin).to have_key(:message)
          expect(plugin.eval_plugin[:message]).to eq "Test failed."
        end

      end

    end

  end

end
