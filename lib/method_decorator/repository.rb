require 'method_decorator/decoration'

module MethodDecorator
  class Repository
    class << self

      attr_writer :decorations

      def add_decoration(target_class, target_name, &decoration)
        exists = original_method target_class, target_name
        target_method = target_class.instance_method target_name
        decoration = Decoration.new target_class, target_name, target_method, &decoration
        self.decorations.push(decoration) unless exists
        not exists
      end

      def original_method(target_class, target_name)
        condition = Proc.new { |d| d.target_class.eql?(target_class) and d.target_name.eql?(target_name) }
        decoration = self.decorations.select(&condition).first
        decoration ? decoration.target_method : nil
      end

      def decorations; @decorations ||= [] end

    end
  end
end