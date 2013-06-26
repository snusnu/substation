# encoding: utf-8

require 'spec_helper'

describe Substation::Environment, '#failure_chain' do

  let(:object)   { described_class.new(registry) }
  let(:block)    { lambda { |_| test Spec::FAKE_HANDLER } }
  let(:registry) { { :test =>  Spec::Processor } }

  context "and a block is given" do
    subject { object.failure_chain(&block) }

    let(:dsl)   { Chain::DSL::Builder.call(registry) }
    let(:chain) { Chain.new(dsl.processors(object, Chain::EMPTY, &block)) }

    it { should eql(chain) }
  end

  context "and no block is given" do
    subject { object.failure_chain }

    it { should eql(Chain::EMPTY) }
  end
end
