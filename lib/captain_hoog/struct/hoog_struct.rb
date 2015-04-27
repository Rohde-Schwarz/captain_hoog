module CaptainHoog
  class Struct < ::OpenStruct

    def fetch(key, default = nil)
      if not self.respond_to?(key)
        raise IndexError unless default
        return default
      else
        self.public_send(key)
      end
    end

    def method_missing(method_name, *args, &block)
      if self.to_h.respond_to?(method_name)
        self.to_h.stringify_keys.send(method_name.to_s, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      self.to_h.respond_to?(method_name) || super
    end

  end
end
