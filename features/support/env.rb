require 'cucumber'
require 'aruba/cucumber'

require 'rspec/expectations'

Before do
  hook_path = File.expand_path(File.join(File.dirname(__FILE__),
                               "..",
                               "..",
                               "spec",
                               "fixtures"))
  @dirs = [hook_path]
end
