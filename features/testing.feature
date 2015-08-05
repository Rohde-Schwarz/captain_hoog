Feature: Testing a hook plugin
  In order to have tested hook plugins
  As developer that want to write tests
  I want to have the possibility to test my hook plugins

  Scenario: Testing a hook plugin with RSpec
    Given I wrote a spec "divide_spec" containing:
      """
      require 'bundler'
      require 'bundler/inline'

      gemfile do
        gem 'captain_hoog', path: File.expand_path('../../..', __FILE__)
        gem 'rspec'
        gem 'minitest'
      end

      require 'rspec'
      require 'captain_hoog/test'

      describe 'Test for hook' do
        let(:divide) do
          path = File.expand_path(File.join(File.dirname(__FILE__),
                                            '..',
                                            'fixtures',
                                            'plugins',
                                            'test_plugins',
                                            'divide.rb'))
          File.new(path)
        end

        let(:config) do
          {
            plugin: {
              divide: {
                divider: 12,
                compare_value: 1
              }
            }
          }
        end

        with_plugin :divide, config: :config, silence: true do
          describe 'helpers' do
            describe '#divider' do
              it 'returns 12 as Fixnum' do
                expect(plugin.divider).to eq 12
                expect(plugin.divider).to be_instance_of Fixnum
              end
            end

            describe '#check_equal' do
              it 'returns 1' do
                expect(plugin.check_equal).to be 1
              end
            end
          end

          it 'exits with true' do
            expect(plugin.result[:test]).to be true
          end
        end

      end
      """
    When I run the spec "divide_spec"
    Then I should see the test is passing with "3" example and "0" failures

  Scenario: Testing a hook plugin with Minitest
    Given I wrote a test "divide_test" containing:
    """
    require 'bundler'
    require 'bundler/inline'

    gemfile do
      gem 'captain_hoog', path: File.expand_path('../../..', __FILE__)
      gem 'rspec'
      gem 'minitest'
    end
    
    gem 'minitest'
    require 'minitest/autorun'
    require 'minitest/unit'
    require 'captain_hoog'
    require 'captain_hoog/test'

    class DividePluginTest < Minitest::Test
      def setup
      config = {
        env: {
          suppress_headline: true
        },
        plugin: {
          divide: {
            divider: 12,
            compare_value: 1
          }
        }
      }
      path = File.expand_path(File.join(File.dirname(__FILE__),
                                          '..',
                                          'fixtures',
                                          'plugins',
                                          'test_plugins',
                                          'divide.rb'))
        sandbox = ::CaptainHoog::Test::Sandbox.new(File.new(path), config)
        sandbox.run
        @plugin = sandbox.plugin
      end

      def test_helper_divider
        assert_equal @plugin.divider, 12
      end

      def test_helper_divider_class
        assert_instance_of Fixnum, @plugin.divider
      end

      def test_result
        assert_equal @plugin.result[:test], true
      end
    end
    """
    When I run the test "divide_test"
    Then I should see the test is passing with "3" example and "0" failures
