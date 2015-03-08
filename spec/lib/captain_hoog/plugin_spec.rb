require 'spec_helper'

describe CaptainHoog::Plugin do

  let(:code) do
    <<-CODE

    git.describe "rspec" do |pre|
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
      before do
        plugin.eval_plugin
      end

      it "evaluates the code abd provides #test_helper" do
        expect(plugin).to respond_to(:test_helper) #be_instance_of(Hash)
      end

    end

    describe '#execute' do

      before do
        plugin.eval_plugin
      end

      describe "the returning hash" do

        subject { plugin.execute }

        it "includes the test result at the :result key" do
          expect(subject).to have_key(:result)
          expect(subject[:result]).to be false
        end

        it "includes the test failure message at the :message key" do
          expect(subject).to have_key(:message)
          expect(subject[:message]).to eq "Test failed."
        end

      end
    end

  end

end
