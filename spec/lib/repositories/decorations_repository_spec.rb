# frozen_string_literal: true

require 'spec_helper'
require 'method_decorator/repositories/decorations_repository'

describe MethodDecorator::Repositories::DecorationsRepository do
  let(:repo) { described_class.singleton }
  let(:method_instance) { String.instance_method(:to_s) }

  before { described_class.singleton.decorations = [] }

  describe '#add!' do
    let(:args) { [String, :method_name, method_instance] }
    let(:block) { proc {} }

    subject { repo.add!(*args, &block) }

    context 'when decoration not exists' do
      it { is_expected.to be_truthy }
    end

    context 'when decoration already exists' do
      before { repo.add!(*args, &block) }
      it { expect { subject }.to raise_error(MethodDecorator::Errors::AlreadyDecoratedError) }
    end
  end
end
