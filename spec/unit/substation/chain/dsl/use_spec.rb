# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#use' do
  subject { object.use(processor) }

  let(:object)    { described_class.new(chain) }
  let(:chain)     { EMPTY_ARRAY }
  let(:processor) { Spec::FAKE_PROCESSOR }

  its(:processors) { should include(processor) }
end
