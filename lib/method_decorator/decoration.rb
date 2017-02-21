module MethodDecorator
  class Decoration

    attr_accessor :target_class, :target_method_name, :target_method, :decoration

    def initialize(target_class, target_method_name, target_method, &decoration)
      self.target_class = target_class
      self.target_method_name = target_method_name
      self.target_method = target_method
      self.decoration = block_given? ? Proc.new : nil
    end

  end
end