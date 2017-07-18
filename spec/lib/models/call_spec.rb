# frozen_string_literal: true

require 'spec_helper'
require 'method_decorator/models/call'

describe MethodDecorator::Models::Call do
  describe '#initialize' do
    subject { described_class.new(*args, &block) }

    context 'when klass is missing' do
      let(:args) { [nil, nil] }
      let(:block) { nil }
      let(:error) { '`klass` attribute is required' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when klass is not a class' do
      let(:args) { [:klass, nil] }
      let(:block) { nil }
      let(:error) { '`klass` attribute must be a `Class`' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when method name is missing' do
      let(:args) { [String, nil] }
      let(:block) { nil }
      let(:error) { '`method_name` attribute is required' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when method name is not a symbol' do
      let(:args) { [String, 'method_name'] }
      let(:block) { nil }
      let(:error) { '`method_name` attribute must be a `Symbol`' }

      it { expect { subject }.to raise_error(ArgumentError, error) }
    end

    context 'when everything is ok' do
      let(:args) { [String, :method_name, :a_first_arg, :a_second_arg] }
      let(:block) { proc { :a_block } }
      let(:call) { subject }

      it { expect(call.klass).to eq String }
      it { expect(call.method_name).to eq :method_name }
      it { expect(call.args).to eq %i[a_first_arg a_second_arg] }
      it { expect(call.block).to eq block }
    end
  end
end
