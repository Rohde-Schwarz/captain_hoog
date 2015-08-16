When(/^I run a commit hook that might succeeds$/) do
  FileUtils.chdir(hook_path)
end

When(/^I run the install script with "(.*?)" type flag$/) do |commit_type|
  @dir = git_project_path.to_s
  @cmd =  "bundle exec #{bin_path}/bin/#{executable} install --type #{commit_type} "
  @cmd += "--plugins_dir #{@dir}"
  run_simple(unescape(@cmd), false)
end

When(/^I run the remove script with "(.*?)" type flag$/) do |commit_type|
  @cmd =  "bundle exec #{bin_path}/bin/#{executable} remove --type #{commit_type} "
  @cmd += "--plugins_dir /home"
  run_simple(unescape(@cmd),false)
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
  cmd = "bundle exec #{bin_path}/bin/#{executable} move --from #{from} --to #{to}"
  run_simple(unescape(cmd), false)
end

When(/^I run the install script without "(.*?)" flag$/) do |type_flag|
  cmd = "bundle exec #{bin_path}/bin/#{executable} install"
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
  #require 'pry'
  #binding.pry
  if @spec_executed
    result = all_stdout.split(/\n/).last
    expect(result).to match(/#{success_count} (example|examples), #{failure_count} failures/)
  end
  if @test_executed
    output = output_from(@cmd).split(/\n/).last
    expect(output).to match(/\d+ runs, #{success_count} assertions, #{failure_count} failures/)
  end
end

Given(/^I run the init script with a custom home path$/) do
  @cmd = "bundle exec #{bin_path}/bin/#{executable} init --home #{hook_path}"
  run_simple(unescape(@cmd),false)
end

Then(/^it should create a \.hoog directory$/) do
  expect(File.exists?(File.join(hook_path, '.hoog'))).to be true
end

Then(/^inside the \.hoog directory a treasury directory exists$/) do
  expect(File.exists?(treasury_path)).to be true
end

Then(/^the init script outputs "(.*?)"$/) do |line|
  expect(output_from(@cmd)).to include line
end

Then(/^I get this scripts output$/) do
  puts output_from(@cmd)
end

When(/^I run a hoog named "(.*?)"$/) do |cmd|
  @cmd = cmd
  run_simple(unescape(@cmd), false)
end

Given(/^I pull a plugin repository into the treasury$/) do
  repo_url = hook_git_repo_path
  @cmd = "bundle exec #{bin_path}/bin/#{executable} treasury pull #{repo_url}"
  @cmd += " --home #{treasury_path}"
  run_simple(unescape(@cmd), false)
end

Then(/^the repository is installed in the treasury$/) do
  step "I get this scripts output"
  expect(File.exist?(File.join(treasury_path, 'neverland'))).to be true
end
