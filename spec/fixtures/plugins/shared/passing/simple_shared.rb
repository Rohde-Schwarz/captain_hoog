git do |pre|

  pre.test do
    true
  end

  pre.message do
    "The shared test failed. Prevent you from doing anything."
  end

end
