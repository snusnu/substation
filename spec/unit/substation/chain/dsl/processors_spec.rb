# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#processors' do
  subject { object.processors }

  let(:chain) { Chain::EMPTY }

  context "and a block is given" do
    let(:object)    { described_class.new(chain, &block) }
    let(:block)     { lambda { |_| use(Spec::Processor.new(Spec::FAKE_HANDLER)) } }
    let(:processor) { Spec::Processor.new(Spec::FAKE_HANDLER) }

    it { should include(processor) }
  end

  context "and no block is given" do
    let(:object) { described_class.new(chain) }

    it { should be_empty }
  end
end
