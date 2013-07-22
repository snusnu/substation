# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#failure_chain' do
  subject { object.failure_chain(name, failure_chain) }

  let(:object)   { dsl.new([ Spec::FAKE_PROCESSOR ]) }
  let(:dsl)      { described_class::Builder.call(registry) }
  let(:registry) { Environment::DSL.registry(&block) }
  let(:block)    { ->(_) { register(:test, Spec::Processor) } }

  let(:processor)     { Spec::FAKE_PROCESSOR.with_failure_chain(failure_chain) }
  let(:failure_chain) { double }

  context 'when the processor to alter is registered' do
    let(:name) { :test }

    its(:processors) { should include(processor) }

    it 'should replace the processor' do
      expect(subject.processors.length).to be(1)
    end
  end

  context 'when the processor to alter is not registered' do
    let(:name) { :unknown }

    specify {
      expect {
        subject
      }.to raise_error(UnknownProcessor, 'No processor named :unknown is registered')
    }
  end
end
