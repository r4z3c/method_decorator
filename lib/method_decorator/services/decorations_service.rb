# frozen_string_literal: true

require 'method_decorator/repositories/decorations_repository'
require 'method_decorator/repositories/calls_repository'
require 'method_decorator/models/call'

module MethodDecorator
  module Services
    class DecorationsService
      attr_accessor :klass, :method_name, :method_instance, :decoration

      def initialize(klass, method_name, &decoration)
        self.klass = klass
        self.method_name = method_name
        self.method_instance = klass.instance_method(method_name)
        self.decoration = decoration
        self
      end

      def decorate
        add_decoration_to_repository
        override_original_klass_method
        define_helper_methods
        self
      end

      protected

      def add_decoration_to_repository
        self.class.decorations_repository.add!(klass, method_name, method_instance, &decoration)
      end

      def override_original_klass_method # rubocop:disable Metrics/AbcSize
        is_protected = klass.protected_instance_methods.include?(method_name)
        is_private = klass.private_instance_methods.include?(method_name)
        define_decoration_method
        method_name_ = method_name
        klass.instance_eval { protected method_name_ } if is_protected
        klass.instance_eval { private method_name_ } if is_private
      end

      def define_decoration_method
        klass_ = klass
        method_name_ = method_name
        decoration_ = decoration
        klass.send(:define_method, method_name) do |*args, &block|
          MethodDecorator.add_call(klass_, method_name_, *args, &block)
          instance_eval(&decoration_)
        end
      end

      def define_helper_methods
        klass.send(:define_method, :call_args) { MethodDecorator.last_call_args(self) }
        klass.send(:define_method, :call_block) { MethodDecorator.last_call_block(self) }
        define_original_call_helper_method
        define_original_call_with_helper_method
        klass.instance_eval { protected :call_args }
        klass.instance_eval { protected :call_block }
      end

      def define_original_call_helper_method
        klass.send :define_method, :call_original do
          method_name = MethodDecorator.last_call_method_name(self)
          MethodDecorator.call_original_method self, method_name, *call_args, &call_block
        end
      end

      def define_original_call_with_helper_method
        klass.send :define_method, :call_original_with do |*desired_args, &desired_block|
          method_name = MethodDecorator.last_call_method_name(self)
          MethodDecorator.call_original_method self, method_name, *desired_args, &desired_block
        end
      end

      class << self
        def decorate(klass, method_name, &decoration)
          new(klass, method_name, &decoration).decorate
        end

        def add_call(klass, method_name, *args, &block)
          calls_repository.add(klass, method_name, *args, &block)
        end

        def call_original_method(context, method_name, *args, &block)
          klass = get_class_from_context(context)
          method_instance = decorations_repository.original_method_instance_of(klass, method_name)
          method_instance.bind(context).call(*args, &block)
        end

        def last_call_args(context)
          call = last_call_from_context(context)
          call && call.args
        end

        def last_call_block(context)
          call = last_call_from_context(context)
          call && call.block
        end

        def last_call_method_name(context)
          call = last_call_from_context(context)
          call && call.method_name
        end

        def last_call_from_context(context)
          klass = get_class_from_context(context)
          calls_repository.find_call(klass)
        end

        def get_class_from_context(context)
          if get_type_from_context(context).eql? :singleton
            context.singleton_class
          else
            context.class
          end
        end

        def get_type_from_context(context)
          context.class.eql?(Class) ? :singleton : :class
        end

        def decorations_repository
          MethodDecorator::Repositories::DecorationsRepository.singleton
        end

        def calls_repository
          MethodDecorator::Repositories::CallsRepository.singleton
        end
      end
    end
  end
end
