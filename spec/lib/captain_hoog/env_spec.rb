require 'spec_helper'

describe CaptainHoog::Env do

  it "is inherits from Hash" do
    expect(subject.class).to be_subclass_of(Hash)
  end

  describe "treats keys as methods" do

    let(:env){ CaptainHoog::Env.new }

    before do
      env[:foo] = "bar"
    end

    it "raises not a NoMethodError" do
      expect { env.foo }.to_not raise_error
    end

    it "responds to the key as method" do
      expect(env).to respond_to(:foo)
    end

    it "returns the value for the key" do
      expect(env.foo).to eq "bar"
    end

  end

end
