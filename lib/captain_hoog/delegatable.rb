module CaptainHoog
  module Delegatable
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      def delegate_to(target_object)
        define_method :delegate_to do
          self.instance_variable_get("@#{target_object}")
        end
      end
    end

    module InstanceMethods

      def method_missing(method_name, *args, &block)
        if delegate_to.respond_to?(method_name)
          delegate_to.send(method_name, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private=false)
        delegate_to.respond_to?(method_name) || super
      end
    end
  end
end
