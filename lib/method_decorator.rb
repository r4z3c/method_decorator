require 'method_decorator/repository'

module MethodDecorator
  class << self

    def decorate(target_class, target_name, &decoration)
      added = Repository.add_decoration target_class, target_name, &decoration
      target_class.send :define_method, target_name, &decoration if added
      added
    end

    def call_original(target_context, target_name, *original_args, &original_block)
      target_class = target_class target_context
      target_method = Repository.original_method target_class, target_name
      target_method.bind(target_context).call *original_args, &original_block
    end

    def target_class(target_context)
      target_type(target_context).eql?(:singleton) ?
      target_context.singleton_class :
      target_context.class
    end

    def target_type(target_context)
      target_context.class.eql?(Class) ? :singleton : :class
    end

  end
end