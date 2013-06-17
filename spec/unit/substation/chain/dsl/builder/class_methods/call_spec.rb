# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::Builder, '.call' do
  subject { described_class.call(registry) }

  let(:registry) { { :test => Spec::Processor } }

  let(:builder) { mock(:dsl => dsl) }
  let(:dsl)     { mock }

  before do
    described_class.should_receive(:new).with(registry).and_return(builder)
    builder.should_receive(:dsl).and_return(dsl)
  end

  it { should be(dsl) }
end
