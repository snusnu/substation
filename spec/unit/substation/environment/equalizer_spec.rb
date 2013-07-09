# encoding: utf-8

require 'spec_helper'

describe Substation::Environment, 'equalizer behavior' do
  subject { object == other }

  let(:object) { described_class.new(registry, dsl) }
  let(:other)  { described_class.new(other_registry, dsl) }

  let(:registry) { mock }
  let(:dsl)      { mock }

  context 'with an equal registry' do
    let(:other_registry) { registry }

    it { should be(true) }
  end

  context 'with a different registry' do
    let(:other_registry) { mock }

    it { should be(false) }
  end
end
