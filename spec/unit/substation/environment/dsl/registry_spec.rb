# encoding: utf-8

require 'spec_helper'

describe Environment::DSL, '#registry' do
  subject { object.registry }

  let(:guard) { described_class::GUARD }

  context 'when a block is given' do
    let(:object)   { described_class.new(guard, &block) }
    let(:block)    { ->(_) { register :test, Spec::Processor } }
    let(:expected) {
      {
        :test => Processor::Builder.new(:test, Spec::Processor, Processor::Executor::NULL)
      }
    }

    it { should eql(expected) }
  end

  context 'when no block is given' do
    let(:object) { described_class.new(guard) }

    it { should eql({}) }
  end
end
