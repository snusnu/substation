# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#chain' do
  subject { object.chain(other) }

  let(:object)    { described_class.new(chain) }
  let(:chain)     { Chain::EMPTY }
  let(:other)     { [ processor ] }
  let(:processor) { Spec::Processor.new(Spec::FAKE_HANDLER) }

  its(:processors) { should include(processor) }
end
