git.describe "simple" do |pre|

  pre.test do
    config.runtime_count / 12 == 1
  end

  pre.message do
    "The test failed. Prevent you from doing anything."
  end

end
