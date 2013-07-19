# encoding: utf-8

require 'spec_helper'

describe Processor::Transformer::Incoming, '#call' do
  let(:klass) { described_class }

  before do
    allow(handler).to receive(:call).with(request).and_return(expected_data)
  end

  it_behaves_like 'Processor::Call::Incoming#call'
end
