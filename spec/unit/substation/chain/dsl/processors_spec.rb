# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#processors' do
  subject { object.processors }

  let(:processor) { Spec::FAKE_PROCESSOR }
  let(:name)      { mock }

  context "and a block is given" do
    let(:object) { described_class.new(chain, &block) }
    let(:chain)  { EMPTY_ARRAY }
    let(:block)  { lambda { |_| use(Spec::FAKE_PROCESSOR) } }

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
