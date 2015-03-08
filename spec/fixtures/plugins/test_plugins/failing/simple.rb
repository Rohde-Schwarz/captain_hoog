git.describe "foo" do |pre|

  pre.helper :test_helper do
    env.project_dir
  end

  pre.test do
    false
  end

  pre.message do
    "The test failed in #{test_helper}. Prevent you from doing anything."
  end

end
