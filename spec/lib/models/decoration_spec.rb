# frozen_string_literal: true

require 'spec_helper'
require 'method_decorator/models/decoration'
require 'method_decorator/models/call'

describe MethodDecorator::Models::Decoration do
  let(:method_instance) { String.instance_method(:to_s) }

  describe '#initialize' do
    subject { described_class.new(*args, &block) }

    context 'when `klass` attribute is missing' do
      let(:args) { [nil, :method_name, method_instance] }
      let(:block) { proc {} }
      let(:error) { '`klass` attribute is required' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when `klass` attribute is not a class' do
      let(:args) { [:klass, :method_name, method_instance] }
      let(:block) { proc {} }
      let(:error) { '`klass` attribute must be a `Class`' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when `method_name` attribute is missing' do
      let(:args) { [String, nil, method_instance] }
      let(:block) { proc {} }
      let(:error) { '`method_name` attribute is required' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when `method_name` attribute is not a symbol' do
      let(:args) { [String, 'method_name', method_instance] }
      let(:block) { proc {} }
      let(:error) { '`method_name` attribute must be a `Symbol`' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when `method_instance` attribute is missing' do
      let(:args) { [String, :method_name, nil] }
      let(:block) { proc {} }
      let(:error) { '`method_instance` attribute is required' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when `method_instance` attribute is not a unbound method' do
      let(:args) { [String, :method_name, :method_instance] }
      let(:block) { proc {} }
      let(:error) { '`method_instance` attribute must be a `UnboundMethod`' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when `decoration` attribute is missing' do
      let(:args) { [String, :method_name, method_instance] }
      let(:block) { nil }
      let(:error) { '`decoration` attribute is required' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end
  end
end
