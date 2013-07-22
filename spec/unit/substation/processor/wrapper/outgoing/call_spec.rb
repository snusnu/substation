# encoding: utf-8

require 'spec_helper'

describe Processor::Wrapper::Outgoing, '#call' do
  let(:klass) { described_class }

  before do
    expect(handler).to receive(:new).with(response).and_return(expected_data)
  end

  it_behaves_like 'Processor::Call::Outgoing#call'
end
