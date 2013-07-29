# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#definition' do
  subject { object.definition }

  let(:processor) { Spec::FAKE_PROCESSOR }

  context 'and a block is given' do
    let(:object)     { described_class.new(definition, &block) }
    let(:definition) { Chain::Definition.new }
    let(:block)      { ->(_) { use(Spec::FAKE_PROCESSOR) } }

    it { should include(processor) }
  end

  context 'and no block is given' do
    let(:object) { described_class.new(chain) }
    let(:chain)  { Chain::Definition.new([ processor ]) }

    it { should include(processor) }
  end
end
