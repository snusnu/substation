# encoding: utf-8

require 'spec_helper'

describe Substation::Environment::DSL, '.registry' do
  context "when a block is given" do
    subject { described_class.registry(&block) }

    let(:block)    { lambda { |_| register :test, Spec::Processor } }
    let(:expected) { { :test => Spec::Processor } }

    it { should eql(expected) }
  end

  context "when no block is given" do
    subject { described_class.registry }

    it { should eql({}) }
  end
end
