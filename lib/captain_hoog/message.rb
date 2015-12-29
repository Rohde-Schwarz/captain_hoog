module CaptainHoog
  class Message
    
    def initialize(color, body)
      @body  = body
      @color = color
    end

    def call(no_color: true)
      (no_color || will_have_no_color) ? message : message.send(@color)
    end

    def message
      message = @body.call
      check_msg(message)
      message
    end

    private
    def check_msg(msg)
      unless msg.is_a?(String)
        raise CaptainHoog::Errors::MessageResultNotValidError
      end
    end

    def will_have_no_color
      @color.eql?(:none)
    end

  end
end
