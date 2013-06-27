# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#processors' do
  subject { object.processors }

  let(:processor) { Spec::Processor.new(Chain::EMPTY, Spec::FAKE_HANDLER) }

  context "and a block is given" do
    let(:object) { described_class.new(chain, &block) }
    let(:chain)  { Chain::EMPTY }
    let(:block)  { lambda { |_| use(Spec::Processor.new(Chain::EMPTY, Spec::FAKE_HANDLER)) } }

    it { should include(processor) }

    its(:length) { should == 1 }
  end

  context "and no block is given" do
    let(:object) { described_class.new(chain) }
    let(:chain)  { Chain.new([ processor ]) }

    it { should include(processor) }

    its(:length) { should == 1 }
  end
end
