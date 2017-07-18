# frozen_string_literal: true

require 'method_decorator/models/model'

module MethodDecorator
  module Models
    class Call < Model
      attr_accessor :klass, :method_name, :args, :block

      def initialize(klass, method_name, *args, &block)
        self.klass = klass
        self.method_name = method_name
        self.args = *args
        self.block = block
        validate!
      end

      protected

      def validate!
        validate_attr!(:klass, Class)
        validate_attr!(:method_name, Symbol)
      end
    end
  end
end
