require 'method_decorator/repository'

module MethodDecorator

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
      target_class.send :define_method, target_method_name, &decoration
      target_class.instance_eval { protected target_method_name } if is_protected
      target_class.instance_eval { private target_method_name } if is_private
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