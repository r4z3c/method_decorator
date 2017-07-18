# frozen_string_literal: true

module MethodDecorator
  module Models
    class Model
      protected

      def validate!
        raise(NotImplementedError, "`#{self.class}` must override `validate!`")
      end

      def validate_attr!(attr, type)
        value = send(attr)
        invalid_attr!(attr) unless value
        invalid_attr!(attr, "must be a `#{type}`") unless value.is_a?(type)
      end

      def invalid_attr!(attr, error = 'is required')
        raise(ArgumentError, "`#{attr}` attribute #{error}")
      end
    end
  end
end
