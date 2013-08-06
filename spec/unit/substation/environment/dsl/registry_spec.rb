# encoding: utf-8

require 'spec_helper'

describe Environment::DSL, '#registry' do
  subject { object.registry }

  let(:registry) { DSL::Registry.new(guard) }
  let(:guard)    { described_class::GUARD }

  context 'when a block is given' do
    let(:object)   { described_class.new(registry, &block) }
    let(:block)    { ->(_) { register :test, Spec::Processor } }
    let(:expected) {
      DSL::Registry.new(guard, {
        :test => Processor::Builder.new(:test, Spec::Processor, Processor::Executor::NULL)
      })
    }

    it { should eql(expected) }
  end

  context 'when no block is given' do
    let(:object) { described_class.new(registry) }

    it { should eql(registry) }
  end
end
