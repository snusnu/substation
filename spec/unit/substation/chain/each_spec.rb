# encoding: utf-8

require 'spec_helper'

describe Chain, '#each' do
  subject { object.each { |tuple| yields << processor } }

  let(:object)     { described_class.new(processors) }
  let(:processors) { [ processor ] }
  let(:processor)  { Spec::Processor.new(Spec::FAKE_HANDLER) }
  let(:yields)     { [] }

  before do
    object.should be_instance_of(described_class)
  end

  it_should_behave_like 'an #each method'

  it 'yields only processors' do
    subject
    yields.each { |processor| processor.should be_instance_of(Spec::Processor) }
  end

  it 'yields only processors with the expected handler' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to([ processor ])
  end
end

describe Chain do
  subject { described_class.new(processors) }

  let(:processors) { [ processor ] }
  let(:processor)  { Spec::Processor.new(Spec::FAKE_HANDLER) }

  before do
    subject.should be_instance_of(described_class)
  end

  it { should be_kind_of(Enumerable) }

  it 'case matches Enumerable' do
    (Enumerable === subject).should be(true)
  end
end
