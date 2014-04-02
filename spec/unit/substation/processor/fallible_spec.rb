# encoding: utf-8

require 'spec_helper'

describe Processor::Fallible do
  describe '#with_failure_chain' do
    subject { object.with_failure_chain(chain) }

    include_context 'Processor#initialize'

    let(:klass) {
      Class.new {
        include Processor::Incoming
        include Processor::Fallible
      }
    }

    let(:expected)        { klass.new(processor_name, handler, expected_config) }
    let(:expected_config) { processor_config.with_failure_chain(chain) }
    let(:chain)           { double }

    it { should eql(expected) }
  end
end
