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
