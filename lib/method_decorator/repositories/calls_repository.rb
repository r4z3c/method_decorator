# frozen_string_literal: true

require 'method_decorator/models/call'

module MethodDecorator
  module Repositories
    class CallsRepository
      attr_writer :calls

      def add(klass, method_name, *args, &block)
        call = find_call(klass)
        if call
          update_existing_call(call, method_name, *args, &block)
        else
          push_new_call(klass, method_name, *args, &block)
        end
      end

      def find_call(klass)
        calls.find { |call| call.klass.eql?(klass) }
      end

      def update_existing_call(call, method_name, *args, &block)
        call.method_name = method_name
        call.args = *args
        call.block = block
        call
      end

      def push_new_call(klass, method_name, *args, &block)
        calls.push(MethodDecorator::Models::Call.new(klass, method_name, *args, &block))
      end

      def calls
        @calls ||= []
      end

      class << self
        def singleton
          @singleton ||= new
        end
      end
    end
  end
end
