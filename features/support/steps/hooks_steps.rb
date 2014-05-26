When(/^I run a commit hook that might succeeds$/) do
  hook_path = File.expand_path(File.join(File.dirname(__FILE__),
                               "..",
                               "..",
                               "..",
                               "spec",
                               "fixtures"))
  FileUtils.chdir(hook_path)

end

When(/^I run the install script with "(.*?)" type flag$/) do |commit_type|
  path = File.expand_path(File.join(File.dirname(__FILE__),
                               "..",
                               "..",
                               ".."))
  run_simple(unescape("ruby #{path}/bin/githoog install --type #{commit_type}"),
            false)
end

Given(/^I am in a directory that isnt a Git repository$/) do
  not_git_repo = "no_git"
  cd(not_git_repo)
end

Given(/^I am in a directory that is a Git repository$/) do
  git_repo = "with_git"
  cd(git_repo)
end

Then(/^a "(.*?)" hook file exists$/) do |hook_type|
  path = File.expand_path(File.join(File.dirname(__FILE__),
                               "..",
                               "..",
                               "..",
                               "spec",
                               "fixtures",
                               "with_git",
                               ".git",
                               "hooks",
                               hook_type))
  expect(File.exists?(path)).to be true
end
