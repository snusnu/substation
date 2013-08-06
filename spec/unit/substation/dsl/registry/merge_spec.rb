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
