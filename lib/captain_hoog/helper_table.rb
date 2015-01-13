module CaptainHoog
  class HelperTable < ::Array

    def helper_defined?(helper_name)
      defined_helpers.include?(helper_name)
    end

    def defined_helpers
      self.map(&:keys).flatten
    end

    def [](helper_name)
      self.detect do |helper|
        helper.keys.include?(helper_name)
      end
    end
    alias_method :get, :[]

    def set(helper)
      self << helper
    end
  end
end
