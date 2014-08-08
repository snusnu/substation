# encoding: utf-8

require 'spec_helper'

describe Processor::Nest::Incoming do

  describe '#call' do
    subject { object.call(request) }

    let(:klass) { described_class }
    let(:composed_state) { double }

    include_context 'Processor::Call'

    before do
      allow(decomposer).to receive(:call).with(request).and_return(decomposed)
      allow(handler).to receive(:call).with(decomposed).and_return(state)
      allow(observers).to receive(:each).with(no_args).and_yield(observer)
      allow(observer).to receive(:call).with(state)
      allow(composer).to receive(:call).with(request, state) { composed_state }
    end

    context 'with a request' do
    end

    context 'with a successful response' do
      let(:state) { Response::Success.new(request, {}) }

      it { should eql(request.success(composed_state)) }
    end

    context 'with a failure response' do
      let(:state) { Response::Failure.new(request, {}) }

      it { should eql(request.error(composed_state)) }
    end

    context 'with an unknown state' do
      let(:state) { nil }

      it 'raises RuntimeError' do
        expect { subject }.to raise_error(RuntimeError, 'Illegal state returned from the invoked handler')
      end
    end
  end

end
