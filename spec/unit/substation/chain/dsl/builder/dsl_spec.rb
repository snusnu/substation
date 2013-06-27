# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::Builder, '#dsl' do
  subject { dsl.new(processors, &block) }

  let(:dsl)        { builder.dsl }
  let(:builder)    { described_class.new(registry) }
  let(:registry)   { { :test => { :class => Spec::Processor, :block => nil } } }
  let(:processors) { [] }
  let(:block)      { lambda { |_| test(Spec::FAKE_HANDLER) } }

  let(:processor)  { Spec::Processor.new(Chain::EMPTY, Spec::FAKE_HANDLER) }

  it "should register instantiated processors" do
    expect(subject.processors).to include(processor)
  end

  it "should create a subclass of Chain::DSL" do
    expect(subject.class).to be < Chain::DSL
  end
end
