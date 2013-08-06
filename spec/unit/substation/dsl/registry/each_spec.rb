# encoding: utf-8

require 'spec_helper'

describe DSL::Registry, '#each' do
  subject { object.each(&block) }

  let(:object)  { described_class.new(guard, entries) }
  let(:guard)   { double('guard') }
  let(:entries) { { name => entry } }
  let(:name)    { double('name') }
  let(:entry)   { double('entry') }
  let(:block)   { ->(_) { } }

  it_should_behave_like 'an #each method'

  it 'yields all entries' do
    expect { |block| object.each(&block) }.to yield_successive_args([name, entry])
  end
end

describe Chain::Definition do
  subject { described_class.new }

  it { should be_kind_of(Enumerable) }
end
