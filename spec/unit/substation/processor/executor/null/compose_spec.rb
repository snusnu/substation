# encoding: utf-8

require 'spec_helper'

describe Processor::Executor::NULL, '#compose' do
  subject { described_class.compose(input, output) }

  let(:input)  { double('input') }
  let(:output) { double('output') }

  it 'should return the output unaltered' do
    expect(subject).to be(output)
  end
end
