# encoding: utf-8

require 'spec_helper'

describe Substation::Environment, '.build' do
  subject { described_class.build(&block) }

  let(:block)    { ->(_) { register(:test, Substation) } }
  let(:expected) { described_class.new(registry) }
  let(:registry) { described_class::DSL.registry(&block) }

  it { should eql(expected) }
end
