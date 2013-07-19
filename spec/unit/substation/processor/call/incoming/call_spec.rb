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
    allow(handler).to receive(:call).with(request).and_return(expected_data)
  end

  it_behaves_like 'Processor::Call::Incoming#call'
end
