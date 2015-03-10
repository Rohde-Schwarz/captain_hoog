module CaptainHoog
  # Public: Class that evaluates a plugin from a given bunch of DSL code.
  class Plugin
    include Delegatable

    attr_accessor :env

    delegate_to :eigenplugin

    # Public: Initializes the Plugin evaluator.
    #
    # code - the plugin code as String
    # env  - An instance of CaptainHoog::Env containing some accessible
    #        environment variables (context is limited to CaptainHoog)
    def initialize(code,env)
      @code  = code
      @env   = env
      @git   = CaptainHoog::Git.new
    end

    # Public: Yields the code given in @code.
    def git
      eigenplugin
    end

    # Public: Evaluates the plugin by 'reading' the dsl. Did not execute
    # anything.
    #
    # Returns nothing
    def eval_plugin
      instance_eval(@code)
    end

    # Public: Executes a plugin and stores the results in a Hash.
    #
    # Returns a Hash containing the test result and the failure message.
    def execute
      eigenplugin.execute
      {
        :result  => @git.instance_variable_get(:@test_result),
        :message => @git.instance_variable_get(:@message)
      }
    end

    private

    def eigenplugin
      @eigenplugin ||= Class.new do
        include Delegatable
        attr_reader :plugin_name

        delegate_to :git

        def initialize(git)
          @git = git
        end

        def describe(name)
          @plugin_name = name
          yield(@git) if block_given?
        end

      end.new(@git)
    end

  end
end
