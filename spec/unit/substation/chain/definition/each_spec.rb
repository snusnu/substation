# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#each' do
  subject { object.each { |tuple| yields << processor } }

  let(:object)     { described_class.new(processors) }
  let(:processors) { [ processor ] }
  let(:processor)  { double('processor', :name => name) }
  let(:name)       { double('name') }
  let(:yields)     { [] }

  before do
    expect(object).to be_instance_of(described_class)
  end

  it_should_behave_like 'an #each method'

  it 'yields all processors' do
    expect { subject }.to change { yields.dup }
      .from([])
      .to([ processor ])
  end
end

describe Chain::Definition do
  subject { described_class.new }

  before do
    expect(subject).to be_instance_of(described_class)
  end

  it { should be_kind_of(Enumerable) }
end
