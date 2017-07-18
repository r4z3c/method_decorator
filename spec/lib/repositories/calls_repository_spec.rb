# frozen_string_literal: true

require 'spec_helper'
require 'method_decorator/repositories/calls_repository'

describe MethodDecorator::Repositories::CallsRepository do
  let(:repo) { described_class.singleton }

  describe '#add' do
    let(:common_args) { [String, :method_name, :a_first_arg, :a_second_arg] }
    let(:block) { proc {} }

    before { repo.calls = [] }

    subject { repo.add(*args, &block) }

    context 'when call not exists' do
      let(:args) { common_args }

      before { subject }

      it { expect(repo.calls.count).to eq 1 }
      it { expect(subject[0].klass).to eq String }
      it { expect(subject[0].method_name).to eq :method_name }
      it { expect(subject[0].args).to eq %i[a_first_arg a_second_arg] }
      it { expect(subject[0].block).to eq block }
    end

    context 'when call already exists' do
      let(:args) { [String, :another_method_name, :another_arg] }

      before { repo.add(*common_args, &block) }
      before { subject }

      it { expect(repo.calls.count).to eq 1 }
      it { expect(subject.klass).to eq String }
      it { expect(subject.method_name).to eq :another_method_name }
      it { expect(subject.args).to eq %i[another_arg] }
      it { expect(subject.block).to eq block }
    end
  end
end
