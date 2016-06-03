module MethodDecorator extend ActiveSupport::Concern

  included do

    class << self

      private

      def decorate_method(target, &block)
        original_method_name = original_method_name_for target
        complex_method_name = decorated_method_name_for target

        alias_method original_method_name, target
        define_method complex_method_name, &block
        alias_method target, complex_method_name
      end

      def original_method_name_for(target)
        "original_#{target}"
      end

      def decorated_method_name_for(target)
        "decorated_#{target}"
      end

    end

    private

    def call_original_method(target, *args, &block)
      original_method_name = self.singleton_class.send :original_method_name_for, target
      send original_method_name, *args, &block
    end

  end

end