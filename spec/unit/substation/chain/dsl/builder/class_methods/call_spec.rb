# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::Builder, '.call' do
  subject { described_class.call(registry) }

  let(:registry) { { :test => Spec::Processor } }

  let(:builder) { double(:dsl => dsl) }
  let(:dsl)     { double }

  before do
    expect(described_class).to receive(:new).with(registry).and_return(builder)
    expect(builder).to receive(:dsl).and_return(dsl)
  end

  it { should be(dsl) }
end
