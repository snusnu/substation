# encoding: utf-8

require 'spec_helper'

describe Processor::Executor, '#compose' do
  subject { executor.compose(input, output) }

  include_context 'Processor::Executor#initialize'

  let(:input)  { double('input') }
  let(:output) { double('output') }

  before do
    expect(composer).to receive(:call).with(input, output).and_return(composed)
  end

  it { should be(composed) }
end
