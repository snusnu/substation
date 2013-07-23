# encoding: utf-8

require 'spec_helper'

describe Processor, '#call' do

  context 'when the processor is no evaluator' do
    it_behaves_like 'Processor::Call::Incoming#call' do
      before do
        expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
      end

      let(:klass) {
        Class.new {
          include Processor::Incoming
          include Processor::Call::Incoming
        }
      }
    end
  end

  # needed for rspec-dm2 to cover all processor ivars
  context 'when the processor is an evaluator' do
    it_behaves_like 'Processor::Evaluator#call' do
      let(:klass) { Processor::Evaluator::Request }
    end
  end
end
