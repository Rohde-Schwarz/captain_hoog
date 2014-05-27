module CaptainHoog
  # Public: Class that evaluates a plugin from a given bunch of DSL code.
  class Plugin

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
      yield(@git) if block_given?
    end

    # Public: Evaluates a plugin and stores the results in a Hash.
    #
    # Returns a Hash containing the test result and the failure message.
    def eval_plugin
      instance_eval(@code)
      {
        :result  => @git.instance_variable_get(:@test_result),
        :message => @git.instance_variable_get(:@message)
      }
    end

  end
end
