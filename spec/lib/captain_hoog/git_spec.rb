require 'spec_helper'

describe CaptainHoog::Git do

  describe "DSL" do

    subject{ CaptainHoog::Git.new }

    it "has #test method" do
      expect(subject).to respond_to(:test)
    end

    it "has #message method" do
      expect(subject).to respond_to(:message)
    end

    it "has #env method" do
      expect(subject).to respond_to(:env)
    end

    it "has #env= method" do
      expect(subject).to respond_to(:env=)
    end

    describe "#test" do

      context "returning a non boolean value" do

        it "raises error" do
          expect do
            subject.test do
              "Hello"
            end
          end.to raise_error(CaptainHoog::Errors::TestResultNotValidError)
        end

      end

      context "returning a boolean value" do

        it "did not raises an error" do
          expect do
            subject.test do
              false
            end
          end.not_to raise_error
        end

      end
    end

    describe "#message" do

      context "returning not a String" do

        it "raises an error" do
          expect do
            subject.message do
              1
            end
          end.to raise_error(CaptainHoog::Errors::MessageResultNotValidError)
        end
      end

      context "returning a String" do

        it "raises not an error" do
          expect do
            subject.message do
              "Foo"
            end
          end.not_to raise_error
        end

      end

    end

  end

end
