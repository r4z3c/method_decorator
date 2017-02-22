require 'method_decorator/repository'

module MethodDecorator extend ActiveSupport::Concern

  included do

    class << self

      def decorate(target_method_name, &decoration)
        MethodDecorator.decorate self, target_method_name, &decoration
      end

    end

  end

  class << self

    def decorate(target_class, target_method_name, &decoration)
      raise 'target_method_name must be a symbol' unless target_method_name.is_a? Symbol
      added = add_to_repository(decoration, target_class, target_method_name)
      override_method(decoration, target_class, target_method_name) if added
      added
    end

    protected

    def add_to_repository(decoration, target_class, target_method_name)
      Repository.add(
        target_class,
        target_method_name,
        target_class.instance_method(target_method_name),
        &decoration
      )
    end

    def override_method(decoration, target_class, target_method_name)
      is_protected = target_class.protected_instance_methods.include? target_method_name
      is_private = target_class.private_instance_methods.include? target_method_name
      define_decorated_method decoration, target_class, target_method_name
      target_class.instance_eval { protected target_method_name } if is_protected
      target_class.instance_eval { private target_method_name } if is_private
    end

    def define_decorated_method(decoration, target_class, target_method_name)
      target_class.send :define_method, target_method_name do |*args, &block|
        target_class.send :define_method, :call_args do return *args end
        target_class.send :define_method, :call_block do return block end
        target_class.send :define_method, :call_original do
          MethodDecorator.call_original_method self, target_method_name, *call_args, &call_block
        end
        target_class.send :define_method, :call_original_with do |*desired_args, &desired_block|
          MethodDecorator.call_original_method self, target_method_name, *desired_args, &desired_block
        end
        target_class.instance_eval { protected :call_args }
        target_class.instance_eval { protected :call_block }
        instance_eval &decoration
      end
    end

    public

    def call_original_method(target_context, target_method_name, *original_args, &original_block)
      target_class = target_class_from_context(target_context)
      target_method = Repository.original_target_method_of(target_class, target_method_name)
      target_method.bind(target_context).call(*original_args, &original_block)
    end

    def target_class_from_context(target_context)
      if target_type_from_context(target_context).eql? :singleton
        target_context.singleton_class
      else
        target_context.class
      end
    end

    def target_type_from_context(target_context)
      target_context.class.eql?(Class) ? :singleton : :class
    end

  end

end