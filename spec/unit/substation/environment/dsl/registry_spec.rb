require 'spec_helper'

describe Substation::Environment::DSL, '#registry' do
  subject { object.registry }

  context "when a block is given" do
    let(:object)   { described_class.new(&block) }
    let(:block)    { lambda { |_| register :test, Spec::Processor } }
    let(:expected) { { :test => Spec::Processor } }

    it { should eql(expected) }
  end

  context "when no block is given" do
    let(:object) { described_class.new }

    it { should eql({}) }
  end
end
