# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator::Pivot, '#call' do
  subject { object.call(request) }

  let(:klass) { described_class }

  include_context 'Processor::Call'

  context 'with a successful handler' do
    before do
      expect(decomposer).to receive(:call).with(request).and_return(decomposed)
      expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
      expect(observers).to receive(:each).with(no_args).and_yield(observer)
      expect(observer).to receive(:call).with(handler_result)
      expect(handler_result).to receive(:success?)
    end

    it { should eql(handler_result) }
  end

  context 'with a failing handler' do
    let(:handler_success) { false }
    let(:response)        { Response::Failure.new(request, composed) }

    before do
      expect(decomposer).to receive(:call).with(request).and_return(decomposed)
      expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
      expect(observers).to receive(:each).with(no_args).and_yield(observer)
      expect(observer).to receive(:call).with(handler_result)
      expect(handler_result).to receive(:success?)
      expect(composer).to receive(:call).with(request, handler_output).and_return(composed)
      expect(failure_chain).to receive(:call).with(response).and_return(failure_response)
    end

    it { should eql(failure_response) }
  end
end
