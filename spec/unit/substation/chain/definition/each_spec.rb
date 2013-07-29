# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#each' do
  subject { object.each(&block) }

  let(:object)     { described_class.new(processors) }
  let(:processors) { [ processor ] }
  let(:processor)  { double('processor', :name => name) }
  let(:name)       { double('name') }
  let(:block)      { ->(_) {} }

  it_should_behave_like 'an #each method'

  it 'yields all processors' do
    expect { |block| object.each(&block) }.to yield_successive_args(processor)
  end
end

describe Chain::Definition do
  subject { described_class.new }

  it { should be_kind_of(Enumerable) }
end
