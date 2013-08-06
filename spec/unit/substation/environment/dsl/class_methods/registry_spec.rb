# encoding: utf-8

require 'spec_helper'

describe Substation::Environment::DSL, '.registry' do
  context 'when a block is given' do
    let(:expected) {
      DSL::Registry.new(guard, {
        :test => Processor::Builder.new(:test, Spec::Processor, Processor::Executor::NULL)
      })
    }

    let(:block) { ->(_) { register :test, Spec::Processor } }

    let(:processor_name) { :test }
    let(:registry)       { Hash.new }

    context 'and no guard is given' do
      subject { described_class.registry(&block) }

      let(:guard) { described_class::GUARD }

      it { should eql(expected) }
    end

    context 'and a guard is given' do
      subject { described_class.registry(guard, &block) }

      let(:guard) { double('guard') }

      # FIXME: this expectation should also be specified in the above
      # context but since Guard includes Adamantium::Flat, setting a
      # method expectation on it doesn't work
      before do
        expect(guard).to receive(:call).with(processor_name, registry)
      end

      it { should eql(expected) }
    end
  end

  context 'when no block is given' do
    subject { described_class.registry }

    let(:expected) { DSL::Registry.new(guard) }

    context 'and no guard is given' do
      subject { described_class.registry }

      let(:guard) { described_class::GUARD }

      it { should eql(expected) }
    end

    context 'and a guard is given' do
      subject { described_class.registry(guard) }

      let(:guard) { double('guard') }

      # FIXME: this expectation should also be specified in the above
      # context but since Guard includes Adamantium::Flat, setting a
      # method expectation on it doesn't work
      before do
        expect(guard).to_not receive(:call)
      end

      it { should eql(expected) }
    end
  end
end
