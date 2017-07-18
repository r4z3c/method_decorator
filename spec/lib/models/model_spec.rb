# frozen_string_literal: true

require 'spec_helper'
require 'method_decorator/models/model'

describe MethodDecorator::Models::Model do
  describe '#validate!' do
    subject { described_class.new.send :validate! }
    it { expect { subject }.to raise_error(NotImplementedError) }
  end
end
