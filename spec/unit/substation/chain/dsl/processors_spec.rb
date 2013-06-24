# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#processors' do
  subject { object.processors }

  let(:env)       { Spec::FAKE_ENV }
  let(:processor) { Spec::FAKE_PROCESSOR }

  context "and a block is given" do
    let(:object) { described_class.new(env, chain, &block) }
    let(:chain)  { Chain::EMPTY }
    let(:block)  { lambda { |_| use(Spec::FAKE_PROCESSOR) } }

    it { should include(processor) }

    its(:length) { should == 1 }
  end

  context "and no block is given" do
    let(:object) { described_class.new(env, chain) }
    let(:chain)  { Chain.new([ processor ]) }

    it { should include(processor) }

    its(:length) { should == 1 }
  end

  # TODO move this elsewhere once mutant supports it
  context "test DSL#initialize" do
    let(:object) { described_class.new(env, chain, &block) }
    let(:chain)  { Chain::EMPTY }
    let(:block)  { lambda { |_| use(Spec::FAKE_PROCESSOR) } }

    it { should include(processor) }

    it "passes down the env to registered processors" do
      subject.first.env.should be(env)
    end
  end
end
