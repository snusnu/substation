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
