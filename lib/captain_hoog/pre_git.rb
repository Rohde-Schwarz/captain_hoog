module CaptainHoog
  class PreGit

    class << self
      attr_accessor :project_dir,
                    :plugins_dir
    end

    def self.run
      pre_git = self.new
      pre_git.plugins_eval
      pre_git
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

    def plugins_eval
      results = @plugins.inject([]) do |result, item|
        result << item.eval_plugin
        result
      end
      tests = results.map{|result| result[:result]}
      if tests.any?{ |test| not test }
        puts "Commit failed. See errors below.".red
        puts "\n"
        results.select{|result| not result[:result] }.each do |result|
          puts result[:message].red
        end
        exit 1 unless ENV["PREGIT_ENV"] == "test"
      else
        puts "All tests passed. No reason to prevent the commit.".green
        exit 0 unless ENV["PREGIT_ENV"] == "test"
      end
    end

    private

    def prepare_env
      env = Env.new
      env[:project_dir] = self.class.project_dir
      env
    end

  end

end
