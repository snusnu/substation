# encoding: utf-8

require 'spec_helper'

describe Processor::Wrapper::Incoming, '#call' do
  let(:klass) { described_class }

  before do
    expect(handler).to receive(:new).with(decomposed).and_return(handler_result)
  end

  it_behaves_like 'Processor::Call::Incoming#call'
end
