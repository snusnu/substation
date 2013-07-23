# encoding: utf-8

require 'spec_helper'

describe Processor::Call::Incoming, '#call' do
  let(:klass) {
    Class.new {
      include Processor::Incoming
      include Processor::Call::Incoming
    }
  }

  before do
    expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
  end

  it_behaves_like 'Processor::Call::Incoming#call'
end
