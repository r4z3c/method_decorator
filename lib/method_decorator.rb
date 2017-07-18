# frozen_string_literal: true

require 'active_support/concern'
require 'method_decorator/services/decorations_service'

module MethodDecorator
  extend ActiveSupport::Concern

  class_methods do
    def decorate(method_name, &decoration)
      MethodDecorator.decorate self, method_name, &decoration
    end
  end

  class << self
    def decorate(klass, method_name, &decoration)
      decorations_service.decorate(klass, method_name, &decoration)
    end

    def add_call(klass, method_name, *args, &block)
      decorations_service.add_call(klass, method_name, *args, &block)
    end

    def call_original_method(context, method_name, *args, &block)
      decorations_service.call_original_method(context, method_name, *args, &block)
    end

    def last_call_args(context)
      decorations_service.last_call_args(context)
    end

    def last_call_block(context)
      decorations_service.last_call_block(context)
    end

    def last_call_method_name(context)
      decorations_service.last_call_method_name(context)
    end

    def decorations_service
      MethodDecorator::Services::DecorationsService
    end
  end
end
