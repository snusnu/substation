# encoding: utf-8

require 'spec_helper'

describe Substation::Environment, 'equalizer behavior' do
  subject { object == other }

  let(:object) { described_class.new(chain_dsl) }
  let(:other)  { described_class.new(other_chain_dsl) }

  let(:chain_dsl) { double('chain_dsl', :registry => registry) }
  let(:registry)  { double('registry') }

  let(:other_chain_dsl) {
    double('other_chain_dsl', :registry => other_registry)
  }

  context 'with an equal registry' do
    let(:other_registry) { registry }

    it { should be(true) }
  end

  context 'with a different registry' do
    let(:other_registry) { double('other_registry') }

    it { should be(false) }
  end
end
