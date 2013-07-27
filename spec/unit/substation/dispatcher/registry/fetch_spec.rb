# encoding: utf-8

require 'spec_helper'

describe Dispatcher::Registry, '#fetch' do

  let(:object) { described_class.new(dispatch_table) }
  let(:name)   { double('name') }

  before do
    expect(name).to receive(:to_sym).and_return(name)
  end

  context 'when name is not yet registered' do
    let(:dispatch_table) { {} }

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

    let(:dispatch_table) { { name => callable } }
    let(:callable)       { double('callable') }

    it { should be(callable) }
  end
end
