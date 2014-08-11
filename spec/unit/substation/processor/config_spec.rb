# encoding: utf-8

require 'spec_helper'

describe Processor::Config do
  describe '#executor' do
    subject { processor_config.executor }

    include_context 'Processor::Config#initialize'

    it { should be(executor) }
  end

  describe '#failure_chain' do
    subject { processor_config.failure_chain }

    include_context 'Processor::Config#initialize'

    it { should be(failure_chain) }
  end

  describe '#observers' do
    subject { processor_config.observers }

    include_context 'Processor::Config#initialize'

    it { should be(observers) }
  end

  describe '#with_failure_chain' do
    subject { processor_config.with_failure_chain(other_failure_chain) }

    let(:other_failure_chain) { double('other failure chain') }
    let(:object) { described_class.new(executor, other_failure_chain, observers) }

    include_context 'Processor::Config#initialize'

    it { should eql(object) }
  end
end
