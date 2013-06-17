require 'spec_helper'

describe Substation::Environment, '#chain' do

  let(:object) { described_class.build(&block) }

  let(:expected) { Chain.build(dsl, other, &chain) }
  let(:other)    { Chain::EMPTY }
  let(:chain)    { lambda { |_| test Spec::FAKE_HANDLER } }
  let(:dsl)      { Chain::DSL::Builder.call(registry) }
  let(:registry) { described_class::DSL.registry(&block) }
  let(:block)    { lambda { |_| register(:test, Spec::Processor) } }

  context "when other is not given" do
    context "and a block is given" do
      subject { object.chain(&chain) }

      it { should eql(expected) }
    end

    context "and no block is given" do
      subject { object.chain }

      let(:expected) { Chain.build(dsl, other) }

      it { should eql(expected) }
    end
  end

  context "when other is given" do
    context "and a block is given" do
      subject { object.chain(other, &chain) }

      it { should eql(expected) }
    end

    context "and no block is given" do
      subject { object.chain(other) }

      let(:expected) { Chain.build(dsl, other) }

      it { should eql(expected) }
    end
  end
end
