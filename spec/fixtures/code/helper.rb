git.describe "helper" do |pre|
  pre.helper :my_helper do
    12
  end

  pre.test do
    false
  end

  pre.message do
    "It's #{my_helper}."
  end
end
