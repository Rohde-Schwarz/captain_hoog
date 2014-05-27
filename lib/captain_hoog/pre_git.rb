module CaptainHoog
  # Public: Entry class for handling a Pre-Something with plugins.
  class PreGit

    class << self
      attr_accessor :project_dir,
                    :plugins_dir,
                    :headline_on_success,
                    :headline_on_failure,
                    :suppress_headline
    end

    # Public: Runs the hook.
    #
    # Inits a new instance of self and evaluates the plugins (if found some)
    #
    # Returns an instance of self (CaptainHoog::PreGit)
    def self.run
      pre_git = self.new
      pre_git.plugins_eval
      pre_git
    end

    # Public: Configures the hook by calling the class' accessors.
    #
    # Returns nothing.
    def self.configure
      yield(self) if block_given?
    end

    def initialize
      env = prepare_env
      @plugins = []
      if self.class.plugins_dir
        Dir["#{self.class.plugins_dir}/**/**.rb"].each do |plugin|
          code = File.read(plugin)
          @plugins << Plugin.new(code,env)
        end
      end
    end

    # Public: Evaluates all plugins that are found in plugins_dir.
    #
    # If any plugin contains a test that returns false (means it fails)
    # it displays the plugins failure messages and exits with code 1
    #
    def plugins_eval
      @results = @plugins.inject([]) do |result, item|
        result << item.eval_plugin
        result
      end
      tests = @results.map{|result| result[:result]}
      if tests.any?{ |test| not test }
        message_on_failure
        exit 1 unless ENV["PREGIT_ENV"] == "test"
      else
        message_on_success
        exit 0 unless ENV["PREGIT_ENV"] == "test"
      end
    end

    private

    def prepare_env
      env = Env.new
      env[:project_dir] = self.class.project_dir
      env
    end

    def message_on_success
      puts defined_message_on(:success).green unless self.class.suppress_headline
    end

    def message_on_failure
      unless self.class.suppress_headline
        puts defined_message_on(:failure).red
        puts "\n"
        @results.select{|result| not result[:result] }.each do |result|
          puts result[:message].red
        end
      end
    end

    def defined_message_on(type)
      if self.class.send("headline_on_#{type}")
        self.class.send("headline_on_#{type}")
      else
        default_messages[type]
      end
    end

    def default_messages
      {
        success: "All tests passed. No reason to prevent the commit.",
        failure: "Commit failed. See errors below."
      }
    end

  end

end
