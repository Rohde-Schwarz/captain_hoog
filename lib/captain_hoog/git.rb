module CaptainHoog
  class Git

    attr_accessor :env

    def initialize
      @helper_table = HelperTable.new
    end

    def test(&test_block)
      if test_block
        @test_block = test_block
      end
    end

    def message(color: :red, &blk)
      if blk
        @message = Class.new do
          def initialize(color, body)
            @body  = body.call
            @color = color
            check_msg(@body)
          end

          def call(no_color: true)
            (no_color || will_have_no_color) ? @body : @body.send(@color)
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

        end.new(color, blk)
      end
    end

    def helper(name,&block)
      return if @helper_table.helper_defined?(name)
      helper_proc = {}
      helper_proc[name] = block
      @helper_table.set(helper_proc)
    end

    def run(&run_block)
      @test_result = true
      @run_block   = run_block
    end

    # Public: Renders a table.
    #
    # rows - An Array of row contents
    # headings - An Array of headlines
    #
    # Returns the table as String.
    def render_table(rows, headings = [])
      table = ::Terminal::Table.new(headings: headings, rows: rows)

      table.to_s
    end

    def method_missing(meth_name, *args, &block)
      super unless @helper_table.helper_defined?(meth_name)
      helper = @helper_table[meth_name]
      fail ArgumentError unless helper[meth_name].arity == args.size
      helper[meth_name].call(*args)
    end

    def respond_to_missing?(meth_name, include_private = false)
      @helper_table.helper_defined?(meth_name) || super
    end

    def execute
      if @test_block
        @test_result = @test_block.call
      else
        # run #run
        @run_block.call
      end
      unless @test_result.is_a?(FalseClass) or @test_result.is_a?(TrueClass)
        raise CaptainHoog::Errors::TestResultNotValidError
      end
    end
  end
end
