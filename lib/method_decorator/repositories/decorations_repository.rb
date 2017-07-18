# frozen_string_literal: true

require 'method_decorator/models/decoration'
require 'method_decorator/models/call'
require 'method_decorator/errors/already_decorated_error'

module MethodDecorator
  module Repositories
    class DecorationsRepository
      attr_writer :decorations

      def add!(klass, method_name, method_instance, &decoration)
        added = add(klass, method_name, method_instance, &decoration)
        self.class.raise_already_decorated_error(klass, method_name) unless added
        added
      end

      def add(klass, method_name, method_instance, &decoration)
        existing = original_method_instance_of(klass, method_name)
        unless existing
          decorations.push(
            Models::Decoration.new(klass, method_name, method_instance, &decoration)
          )
        end
        !existing
      end

      def original_method_instance_of(klass, method_name)
        decoration = find_decoration(klass, method_name)
        decoration ? decoration.method_instance : nil
      end

      def find_decoration(klass, method_name)
        decorations.select do |d|
          d.klass.eql?(klass) && d.method_name.eql?(method_name)
        end.first
      end

      def decorations
        @decorations ||= []
      end

      class << self
        def raise_already_decorated_error(klass, method_name)
          raise(
            MethodDecorator::Errors::AlreadyDecoratedError,
            "`#{klass}` already has a decorated `#{method_name}`"
          )
        end

        def singleton
          @singleton ||= new
        end
      end
    end
  end
end
