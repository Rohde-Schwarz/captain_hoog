module CaptainHoog
  # Public: Entry class for handling a Pre-Something with plugins.
  class PreGit
    module PluginDirs
      module_function
      def collect(plugins_dir)
        treasury_path = CaptainHoog.treasury_path
        if File.exist?(treasury_path)
          Dir["#{treasury_path}/**"].each_with_object(plugins_dir) do |dir, res|
            res << dir if File.directory?(dir)
          end
        end
      end
    end
    
    %i{ project_dir
        headline_on_success
        headline_on_failure
        suppress_headline
        plugins_conf }.each do |class_method|
      singleton_class.send(:attr_accessor, class_method)
    end

    singleton_class.send(:attr_reader, :plugins_dir)

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

    def self.plugins_dir=(plugins_dir)
      @plugins_dir = []
      PluginDirs.collect(@plugins_dir)
      (@plugins_dir << plugins_dir).flatten!
    end

    def initialize(plugins_list = nil)
      @plugins      = []
      @plugins_list = plugins_list
      prepare_plugins
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
      env[:project_dir]    = self.class.project_dir
      env[:plugins_config] = self.class.plugins_conf
      env
    end

    def message_on_success
      puts defined_message_on(:success).green unless self.class.suppress_headline
    end

    def message_on_failure
      unless self.class.suppress_headline
        puts defined_message_on(:failure)
        puts "\n"
        @results.select{|result| not result[:result] }.each do |result|
          puts result[:message].call(no_color: false)
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
      unless File.basename(dir).match(/test/)
        Dir["#{dir}/**"].each do |file|
          if File.directory?(file)
            read_plugins_from_dir(file, env)
          else
            if File.extname(file).eql?(".rb")
              code = File.read(file)
              @plugins << Plugin.new(code,env)
            end
          end
        end
      end
    end

    def prepare_plugins
      env         = prepare_env
      plugins_dir = self.class.plugins_dir
      (plugins_dir.is_a?(Array) ? plugins_dir : Array(plugins_dir)).each do |dir|
        read_plugins_from_dir(dir, env)
      end
    end

  end

end
