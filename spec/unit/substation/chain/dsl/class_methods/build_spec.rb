# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '.build' do
  subject { described_class.build(*blocks) }

  shared_examples_for 'Chain::DSL.build' do
    it { should be_instance_of(Chain) }

    its(:count) { should be(count) }
  end

  context "and no block is given" do
    let(:blocks) { [] }
    let(:count)  { 0 }

    it_behaves_like 'Chain::DSL.build'
  end

  context "and nil is given" do
    let(:blocks) { [ nil ] }
    let(:count)  { 0 }

    it_behaves_like 'Chain::DSL.build'
  end

  context "and one block is given" do
    let(:blocks)    { [ block ] }
    let(:block)     { lambda { |_| use(Spec::FAKE_PROCESSOR) } }
    let(:processor) { Spec::FAKE_PROCESSOR }
    let(:count)     { 1 }

    it_behaves_like 'Chain::DSL.build'

    it { should include(processor) }
  end
end
