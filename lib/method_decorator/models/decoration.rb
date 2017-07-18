# frozen_string_literal: true

require 'method_decorator/models/model'

module MethodDecorator
  module Models
    class Decoration < Model
      attr_accessor :klass, :method_name, :method_instance, :decoration

      def initialize(klass, method_name, method_instance)
        self.klass = klass
        self.method_name = method_name
        self.method_instance = method_instance
        self.decoration = block_given? ? Proc.new : nil
        validate!
      end

      protected

      def validate!
        validate_attr!(:klass, Class)
        validate_attr!(:method_name, Symbol)
        validate_attr!(:method_instance, UnboundMethod)
        validate_attr!(:decoration, Proc)
      end
    end
  end
end
