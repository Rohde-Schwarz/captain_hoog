module CaptainHoog
  module Cli
    module Pull
      module_function

      def pull_and_clone(repository_url, path)
        target_name = File.basename(repository_url.split('/').last, '.git')
        ::Git.clone(repository_url, target_name, path: path)
      rescue
        puts "Default hookin treasury already exists. Skipping.".yellow
      end
    end
  end
end
