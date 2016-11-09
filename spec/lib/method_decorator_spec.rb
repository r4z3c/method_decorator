require 'spec_helper'
require 'support/some_class'

describe MethodDecorator do

  let(:some_arg) { :some_arg }

  subject { target.some_method some_arg }

  before do
    expect(target).to receive(:puts).with(:decorated_some_method).ordered
    expect(target).to receive(:puts).with(some_arg).ordered
  end

  context 'when singleton method context' do
    let(:target) { SomeClass }
    it { subject }
  end

  context 'when instance method context' do
    let(:target) { SomeClass.new }
    let(:methods) { target.class.send :generated_methods }
    it { subject }
  end

end