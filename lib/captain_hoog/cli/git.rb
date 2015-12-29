module CaptainHoog
  module Cli
    module Git
      module_function

      def is_git_repository?
       File.exist?(File.join(Dir.getwd, ".git"))
      end

      def hooks_dir
        git_dir.join(".git", "hooks")
      end

      def git_dir
        Pathname.new(Dir.getwd)
      end

      def check_if_git_present
        if not is_git_repository?
          puts "I can't detect a Git repository".red
          raise Thor::Error
        end
      end
    end
  end
end
