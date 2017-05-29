module CaptainHoog
  module Cli
    autoload :Pull, 'captain_hoog/cli/pull'
    class Treasury < Thor
      include Pull
      
      desc 'pull','Pulls from repository into the treasury'
      option :home, type: :string
      def pull(repository_url)
        path = options[:home] ? options[:home] : CaptainHoog.treasury_path
        pull_and_clone(repository_url, path)
      end
    end
  end
end
