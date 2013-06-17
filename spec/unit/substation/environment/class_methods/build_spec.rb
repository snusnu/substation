require 'spec_helper'

describe Substation::Environment, '.build' do
  subject { described_class.build(&block) }

  let(:block)    { lambda { |_| register(:test, Substation) } }
  let(:expected) { described_class.new(registry) }
  let(:registry) { described_class::DSL.registry(&block) }

  it { should eql(expected) }
end
