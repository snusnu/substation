# encoding: utf-8

require 'spec_helper'

describe Processor::Transformer::Outgoing, '#call' do
  let(:klass) { described_class }

  before do
    allow(handler).to receive(:call).with(response).and_return(expected_data)
  end

  it_behaves_like 'Processor::Call::Outgoing#call'
end
