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

  it { should be_kind_of(Enumerable) }

  it 'yields all entries' do
    expect { |block| object.each(&block) }.to yield_successive_args([name, entry])
  end
end
# encoding: utf-8

require 'spec_helper'

describe DSL::Registry, '#[]=' do
  subject { object[name] = expected }

  let(:object)         { described_class.new(guard) }
  let(:guard)          { DSL::Guard.new(reserved_names) }
  let(:reserved_names) { EMPTY_ARRAY }
  let(:expected)       { double('expected') }
  let(:name)           { double('name', :to_sym => coerced_name) }
  let(:coerced_name)   { double('coerced_name') }

  context 'when name is not yet registered' do
    it { should be(expected) }
  end

  context 'when name is already registered' do
    let(:msg) { DSL::Guard::ALREADY_REGISTERED_MSG % coerced_name.inspect }

    before { object[name] = expected }

    specify { expect { subject }.to raise_error(AlreadyRegisteredError, msg) }
  end

  context 'when name is reserved' do
    let(:msg)            { DSL::Guard::RESERVED_NAME_MSG % coerced_name.inspect }
    let(:reserved_names) { [coerced_name] }

    specify { expect { subject }.to raise_error(ReservedNameError, msg) }
  end
end
# encoding: utf-8

require 'spec_helper'

describe DSL::Registry, '#fetch' do

  let(:object)       { described_class.new(guard, entries) }
  let(:guard)        { double('guard') }
  let(:name)         { double('name') }
  let(:coerced_name) { double('coerced_name') }

  before do
    expect(name).to receive(:to_sym).and_return(coerced_name)
  end

  context 'when name is not yet registered' do
    let(:entries) { {} }

    context 'and a block is given' do
      subject { object.fetch(name, &block) }

      let(:block)          { ->(_) { block_return } }
      let(:block_return)   { double('block_return') }

      it { should be(block_return) }
    end

    context 'and no block is given' do
      subject { object.fetch(name) }

      it 'should behave like Hash#fetch' do
        expect { subject }.to raise_error(KeyError)
      end
    end
  end

  context 'when name is already registered' do
    subject { object.fetch(name) }

    let(:entries)  { { coerced_name => expected } }
    let(:expected) { double('expected') }

    it { should be(expected) }
  end
end
# encoding: utf-8

require 'spec_helper'

describe DSL::Registry, '#include?' do
  subject { object.include?(name) }

  let(:object)       { described_class.new(guard, entries) }
  let(:guard)        { double('guard') }
  let(:name)         { double('name') }
  let(:coerced_name) { double('coerced_name') }

  before do
    expect(name).to receive(:to_sym).with(no_args).and_return(coerced_name)
  end

  context 'when name is included' do
    let(:entries)  { { coerced_name => data } }
    let(:data)     { double('data') }

    it { should be(true) }
  end

  context 'when name is not included' do
    let(:entries) { {} }

    it { should be(false) }
  end
end
# encoding: utf-8

require 'spec_helper'

describe DSL::Registry, '#keys' do
  subject { object.keys }

  let(:object)  { described_class.new(guard, entries) }
  let(:guard)   { double('guard') }
  let(:entries) { { key => value } }
  let(:key)     { double('key') }
  let(:value)   { double('value') }

  it { should eql([key]) }
end
# encoding: utf-8

require 'spec_helper'

describe DSL::Registry, '#merge' do
  subject { object.merge(other) }

  let(:other)        { described_class.new(guard, entries) }
  let(:entries)      { { coerced_name => data } }
  let(:data)         { double('data') }

  let(:guard)        { double('guard') }
  let(:name)         { double('name') }
  let(:coerced_name) { double('coerced_name') }

  before do
    expect(coerced_name).to receive(:to_sym).with(no_args).and_return(coerced_name)
  end

  context 'when other contains equally named objects' do
    before do
      expect(guard).to receive(:call).with(coerced_name, entries).and_raise(RuntimeError)
    end

    let(:object) { described_class.new(guard, entries) }

    it 'raises an error' do
      expect { subject }.to raise_error(RuntimeError)
    end
  end

  context 'when other only contains new names as keys' do
    before do
      expect(guard).to receive(:call).with(coerced_name, {})
    end

    let(:object)   { described_class.new(guard) }
    let(:expected) { described_class.new(guard, entries) }

    it { should eql(expected) }
    it { should_not be(object) }
  end
end
