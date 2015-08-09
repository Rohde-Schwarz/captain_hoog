require 'cucumber'
require 'aruba/cucumber'

require 'rspec/expectations'

SPEC_PATH = File.expand_path(File.join(File.dirname(__FILE__),
                             "..",
                             "..",
                             "spec"))

FIXTURES_PATH  = File.join(SPEC_PATH, "fixtures")
HOOK_SPEC_PATH = File.join(SPEC_PATH, "hooks")

Before do
  $git_fixture_dir_exists ||= false
  @dirs = [FIXTURES_PATH]
  ["no_git", "with_git"].each do |dir|
    git_path = File.join(FIXTURES_PATH, dir)
    FileUtils.mkdir_p(git_path)
    if dir.eql?("with_git")
      Dir.chdir(git_path)
      `git init .`
    end
  end
  $git_fixture_dir_exists = true
  unless File.exists?(HOOK_SPEC_PATH)
    FileUtils.mkdir(HOOK_SPEC_PATH)
  end
end


After do
  FileUtils.rm_rf(File.join(FIXTURES_PATH, '.hoog'))
  FileUtils.rm_rf(File.join(FIXTURES_PATH, 'with_git', 'hoogfile.yml'))
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
    FileUtils.rm_rf(HOOK_SPEC_PATH)
  end
end
