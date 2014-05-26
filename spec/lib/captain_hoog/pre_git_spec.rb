require 'spec_helper'

describe CaptainHoog::PreGit do

  describe "class methods" do

    subject{ CaptainHoog::PreGit }

    it "provides #run" do
      expect(subject).to respond_to(:run)
    end

    it "provides #project_dir getter" do
      expect(subject).to respond_to(:project_dir)
    end

    it "provides #project_dir setter" do
      expect(subject).to respond_to(:project_dir=)
    end

    it "provides #plugins_dir getter" do
      expect(subject).to respond_to(:plugins_dir)
    end

    it "provides #plugins_dir setter" do
      expect(subject).to respond_to(:plugins_dir=)
    end

    describe "#run" do

      it "returns an instance of CaptainHoog::PreGit" do
        expect(CaptainHoog::PreGit.run).to be_instance_of(CaptainHoog::PreGit)
      end

    end

  end

  describe "instance methods" do

    it "provides #plugins_eval" do
      expect(subject).to respond_to(:plugins_eval)
    end

  end

end
