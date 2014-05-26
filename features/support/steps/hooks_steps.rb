When(/^I run a commit hook that might succeeds$/) do
  hook_path = File.expand_path(File.join(File.dirname(__FILE__),
                               "..",
                               "..",
                               "..",
                               "spec",
                               "fixtures"))
  FileUtils.chdir(hook_path)
  
end
