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
    allow(handler).to receive(:call).with(response).and_return(expected_data)
  end

  it_behaves_like 'Processor::Call::Outgoing#call'
end
