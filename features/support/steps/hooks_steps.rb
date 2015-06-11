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
  @dir = git_project_path.to_s
  run_simple(unescape("ruby #{bin_path}/bin/githoog install --type #{commit_type} --plugins_dir #{@dir}"),
            false)
end

When(/^I run the remove script with "(.*?)" type flag$/) do |commit_type|
  run_simple(unescape("ruby #{bin_path}/bin/githoog remove --type #{commit_type} --plugins_dir /home"),
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
  expect(File.exists?(hooks_path(hook_type))).to be true
end

Given(/^a "(.*?)" is present$/) do |hook_type|
  FileUtils.touch(hooks_path(hook_type))
end

Then(/^a "(.*?)" hook file did not exists$/) do |hook_type|
  expect(File.exists?(hooks_path(hook_type))).to be false
end

Given(/^I type in "(.*?)"$/) do |arg1|
  run_simple(arg1)
end

Then(/^I should see the current version$/) do
  expect(all_stdout.split(/\n/).first).to match(/\d{1,}.\d{1,}.\d{1,}/)
end

When(/^I run the move script with "(.*?)" from flag and "(.*?)" to flag$/) do |from, to|
  cmd = "ruby #{bin_path}/bin/githoog move --from #{from} --to #{to}"
  run_simple(unescape(cmd), false)
end

When(/^I run the install script without "(.*?)" flag$/) do |type_flag|
  cmd = "ruby #{bin_path}/bin/githoog install"
  run_simple(unescape(cmd),false)
end

Then(/^a hook config file exists$/) do
  expect(File.exists?(hook_config_file_path)).to be true
end

Then(/^the config file includes the "(.*?)" directory$/) do |config_path|
  config = YAML.load_file(hook_config_file_path)
  expect(config).to have_key("#{config_path}_dir")
  expect(config["#{config_path}_dir"]).to include @dir
end

Given(/^I wrote a spec "([^"]*)" containing:$/) do |name, content|
  write_spec(name, content)
end

Given(/^I wrote a test "([^"]*)" containing:$/) do |name, content|
  write_spec(name, content)
end

When(/^I run the spec "([^"]*)"$/) do |spec_name|
  path = File.join(HOOK_SPEC_PATH, "#{spec_name}.rb")
  cmd = "bundle exec rspec #{path}"
  @spec_executed = true
  run_simple(unescape(cmd), false)
end

When(/^I run the test "([^"]*)"$/) do |test_name|
  path = File.join(HOOK_SPEC_PATH, "#{test_name}.rb")
  @cmd = "ruby #{path}"
  @test_executed = true
  run_simple(unescape(@cmd), false)
end

Then(/^I should see the test is passing with "([^"]*)" example and "([^"]*)" failures$/) do |success_count, failure_count|
  if @spec_executed
    result = all_stdout.split(/\n/).last
    expect(result).to match(/#{success_count} (example|examples), #{failure_count} failures/)
  end
  if @test_executed
    output = output_from(@cmd).split(/\n/).last
    expect(output).to match(/\d+ runs, #{success_count} assertions, #{failure_count} failures/)
  end
end
