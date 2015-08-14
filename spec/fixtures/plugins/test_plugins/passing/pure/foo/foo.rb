git.describe "foo" do |pre|

  pre.test do
    @foo = 1
    true
  end

  pre.message do
    "The #{@foo} what test failed. Prevent you from doing anything."
  end

end
