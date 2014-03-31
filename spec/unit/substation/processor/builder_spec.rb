# encoding: utf-8

require 'spec_helper'

describe Processor::Builder, '#call' do
  subject { object.call(handler, failure_chain, observers) }

  include_context 'Processor::Config#initialize'

  let(:object)    { described_class.new(name, klass, executor) }
  let(:handler)   { double('handler') }
  let(:name)      { double('name') }
  let(:klass)     { double('klass') }
  let(:processor) { double('processor') }

  before do
    expect(klass).to receive(:new).with(name, handler, processor_config).and_return(processor)
  end

  it { should eql(processor) }
end
