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
    def self.run(plugins_list: nil)
      pre_git = self.new(plugins_list)
      pre_git.plugins_eval
      pre_git
    end

    # Public: Configures the hook by calling the class' accessors.
    #
    # Returns nothing.
    def self.configure
      yield(self) if block_given?
    end

    def initialize(plugins_list = nil)
      env           = prepare_env
      @plugins      = []
      @plugins_list = plugins_list
      if self.class.plugins_dir
        read_plugins_from_dir(self.class.plugins_dir, env)
      end
      if shared_plugins_dir_present?
        read_plugins_from_dir(shared_plugins_dir, env)
      end
    end

    # Public: Evaluates all plugins that are found in plugins_dir.
    #
    # If any plugin contains a test that returns false (means it fails)
    # it displays the plugins failure messages and exits with code 1
    #
    def plugins_eval
      raw_results = available_plugins.inject([]) do |result, plugin|
        result << plugin.execute
      end
      @results = raw_results.select{ |result| result.is_a?(Hash) }
      tests    = @results.map{ |result| result[:result] }
      if tests.any?{ |test| not test }
        message_on_failure
        exit 1 unless ENV["PREGIT_ENV"] == "test"
      else
        message_on_success
        exit 0 unless ENV["PREGIT_ENV"] == "test"
      end
    end

    private

    def available_plugins
      @plugins.inject([]) do |result, item|
        item.eval_plugin
        result << item if @plugins_list.has?(item)
        result
      end
    end

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

    def shared_plugins_dir_present?
      File.exists?(shared_plugins_dir)
    end

    def shared_plugins_dir
      File.join(self.class.plugins_dir, "..", "shared")
    end

    def read_plugins_from_dir(dir, env)
      Dir["#{dir}/**/**.rb"].each do |plugin|
        code = File.read(plugin)
        @plugins << Plugin.new(code,env)
      end
    end

  end

end
