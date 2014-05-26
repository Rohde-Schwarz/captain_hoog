require 'cucumber'
require 'aruba/cucumber'

require 'rspec/expectations'

FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__),
                             "..",
                             "..",
                             "spec",
                             "fixtures"))

Before do
  @dirs = [FIXTURES_PATH]
end

After do
  %w{ pre-commit
      pre-push
      pre-rebase
      post-update
      commit-msg
      applypatch-msg
      post-update
      pre-applypatch }.each do |hook_type|
    FileUtils.rm_rf(File.join(FIXTURES_PATH,
                              "with_git",
                              ".git",
                              "hooks",
                              hook_type))
  end
end
