module CaptainHoog
  module Test
    module PluginStrategies
      module Initializer
        def initialize(plugin)
          @plugin = plugin
        end

        def match?
          true
        end

        def to_s
          @plugin
        end
      end

      class File
        include Initializer
        
        def to_s
          ::File.read(@plugin)
        end

        def match?
          @plugin.is_a?(::File)
        end
      end

      class String
        include Initializer

        def match?
          @plugin.is_a?(String)
        end

        def to_s
          self
        end
      end

      class NullObject
        include Initializer

      end
    end
  end
end
