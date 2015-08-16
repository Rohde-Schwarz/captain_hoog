module CaptainHoog
  module Cli
    class Treasury < Thor
      desc 'pull','Pulls from repository into the treasury'
      option :home, type: :string
      def pull(repository_url)
        path = options[:home] ? options[:home] : CaptainHoog.treasury_path
        target_name = File.basename(repository_url.split('/').last, '.git')
        ::Git.clone(repository_url, target_name, path: path)
      end
    end
  end
end
