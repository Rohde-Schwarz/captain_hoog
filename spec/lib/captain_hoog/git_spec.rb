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

    it "has #helper method" do
      expect(subject).to respond_to(:helper)
    end

    it "has #render_table method" do
      expect(subject).to respond_to(:render_table)
    end

    it "has #run method" do
      expect(subject).to respond_to(:run)
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

    describe "#helper" do

      let(:git){ CaptainHoog::Git.new }

      before do
        git.helper :my_helper do

        end
      end

      it "defines a helper method with a given name" do
        expect(git).to respond_to(:my_helper)
      end

      context "passing variables to the helper" do

        before do
          git.helper :my_helper_with_vars do |a|
            a
          end

          git.helper :setter= do |a|

          end
        end

        it "variables will be evaluated" do
          expect do
            git.my_helper_with_vars
          end.to raise_error ArgumentError
          expect do
            git.setter=22
          end.to_not raise_error
          expect(git.my_helper_with_vars(19)).to eq 19
        end

      end

      describe "integrated in a plugin" do

        let(:code) do
          path =File.join(File.dirname(__FILE__),
                          "..",
                          "..",
                          "fixtures",
                          "code",
                          "helper.rb")
          File.read(path)
        end

        it "provides access directly to the helper" do
          plugin = CaptainHoog::Plugin.new(code, "")

          expect do
            plugin.eval_plugin
          end.to_not raise_error

          expect(plugin.eval_plugin[:message]).to eq "It's 12."
        end

      end

    end

    describe "#run" do

      it "sets @test_result to true" do
        subject.run do
          "hello"
        end
        expect(subject.instance_variable_get(:@test_result)).to be true
      end

      it "evaluates the given block" do
        subject.run do
          subject.helper :foo_run do
            12
          end
        end
        expect(subject).to respond_to(:foo_run)
      end

    end
  end

end
