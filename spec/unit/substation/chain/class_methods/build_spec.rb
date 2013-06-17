require 'spec_helper'

describe Chain, '.build' do

  context "when a block is given" do
    subject { described_class.build(dsl, other, &block) }

    let(:dsl)       { Chain::DSL::Builder.call(registry) }
    let(:registry)  { { :test => Spec::Processor } }
    let(:other)     { [ processor ] }
    let(:processor) { Spec::Processor.new(Spec::FAKE_HANDLER) }
    let(:block)     { lambda { |_| test(Spec::FAKE_HANDLER) } }

    let(:expected)  { Chain.new(dsl.processors(other, &block)) }

    it { should eql(expected) }
  end

  context "when no block is given" do
    subject { described_class.build(dsl, other) }

    let(:dsl)       { Chain::DSL::Builder.call(registry) }
    let(:registry)  { { :test => Spec::Processor } }
    let(:other)     { [ processor ] }
    let(:processor) { Spec::Processor.new(Spec::FAKE_HANDLER) }

    let(:expected)  { Chain.new(dsl.processors(other)) }

    it { should eql(expected) }
  end
end
