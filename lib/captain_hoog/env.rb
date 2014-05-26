module CaptainHoog
  class Env < Hash

    def method_missing(meth_name, *args, &block)
      if self.has_key?(meth_name)
        return self[meth_name]
      else
        super
      end
    end

    def respond_to_missing?(meth_name, include_private = false)
      self.has_key?(meth_name) || super
    end

  end
end
