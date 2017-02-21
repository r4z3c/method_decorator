require 'method_decorator/decoration'

module MethodDecorator
  class Repository
    class << self

      attr_writer :decorations

      def add(target_class, target_method_name, target_method, &decoration)
        exists = original_target_method_of target_class, target_method_name

        self.decorations.push(
          Decoration.new target_class, target_method_name, target_method, &decoration
        ) unless exists

        not exists
      end

      def original_target_method_of(target_class, target_method_name)
        decoration = self.decorations.select do
          |d| d.target_class.eql?(target_class) and d.target_method_name.eql?(target_method_name)
        end.first

        decoration ? decoration.target_method : nil
      end

      def decorations; @decorations ||= [] end
    end
  end
end