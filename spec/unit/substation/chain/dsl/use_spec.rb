# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#use' do
  subject { object.use(processor) }

  let(:object)     { described_class.new(definition) }
  let(:definition) { Chain::Definition.new }
  let(:processor)  { Spec::FAKE_PROCESSOR }

  its(:definition) { should include(processor) }
end
