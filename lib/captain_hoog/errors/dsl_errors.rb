module CaptainHoog
  module Errors
    TestResultNotValidError     = Class.new(StandardError)
    MessageResultNotValidError  = Class.new(TestResultNotValidError)
  end
end
