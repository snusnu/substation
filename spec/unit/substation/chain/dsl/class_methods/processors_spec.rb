# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '.processors' do

  let(:chain) { Chain::EMPTY }

  context "and a block is given" do
    subject { described_class.processors(chain, &block) }

    let(:block)     { lambda { |_| use(Spec::FAKE_PROCESSOR) } }
    let(:processor) { Spec::FAKE_PROCESSOR }

    it { should include(processor) }
  end

  context "and no block is given" do
    subject { described_class.processors(chain) }

    it { should be_empty }
  end
end
