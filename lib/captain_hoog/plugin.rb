module CaptainHoog
  class Plugin

    def initialize(code,env)
      @code  = code
      @env   = env
      @git   = CaptainHoog::Git.new
    end

    def git
      yield(@git) if block_given?
    end

    def eval_plugin
      instance_eval(@code)
      {
        :result  => @git.instance_variable_get(:@test_result),
        :message => @git.instance_variable_get(:@message)
      }
    end

  end
end
