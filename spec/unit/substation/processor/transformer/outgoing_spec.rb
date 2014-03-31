# encoding: utf-8

require 'spec_helper'

describe Processor::Transformer::Outgoing, '#call' do
  let(:klass) { described_class }

  before do
    expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
    expect(observers).to receive(:each).with(no_args).and_yield(observer)
    expect(observer).to receive(:call).with(handler_result)
  end

  it_behaves_like 'Processor::Call::Outgoing#call'
end
