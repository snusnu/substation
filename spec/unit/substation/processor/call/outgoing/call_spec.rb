# encoding: utf-8

require 'spec_helper'

describe Processor::Call::Outgoing, '#call' do
  let(:klass) {
    Class.new {
      include Processor::Outgoing
      include Processor::Call::Outgoing
    }
  }

  before do
    expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
  end

  it_behaves_like 'Processor::Call::Outgoing#call'
end
