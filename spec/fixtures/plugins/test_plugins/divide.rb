git.describe 'divide' do |hook|
  hook.helper :divider do
    config.divider.to_i
  end

  hook.helper :check_equal do
    config.compare_value
  end

  hook.test do
    (12/divider) == check_equal
  end

  hook.message do
    "Dividing fails"
  end
end
