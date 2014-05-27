module CaptainHoog
  class Git

    attr_accessor :env

    def test
      if block_given?
        @test_result = yield
        unless @test_result.is_a?(FalseClass) or @test_result.is_a?(TrueClass)
          raise CaptainHoog::Errors::TestResultNotValidError
        end
      end
    end

    def message
      if block_given?
        @message = yield
        unless @message.is_a?(String)
          raise CaptainHoog::Errors::MessageResultNotValidError
        end
      end
    end

    def helper(name,&block)
      self.class.send(:define_method, name, &block)
    end

  end
end
