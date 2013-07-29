# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#chain' do
  subject { object.chain(other) }

  let(:object)     { described_class.new(definition) }
  let(:definition) { Chain::Definition.new }
  let(:other)      { [ processor ] }
  let(:processor)  { Spec::FAKE_PROCESSOR }

  its(:definition) { should include(processor) }
end
