git.describe "foo" do |pre|

  pre.test do
    true
  end

  pre.message do
    "The what test failed. Prevent you from doing anything."
  end

end
