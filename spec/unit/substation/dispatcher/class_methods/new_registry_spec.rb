# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '.new_registry' do
  subject { described_class.new_registry }

  let(:expected) { DSL::Registry.new(described_class::GUARD) }

  it { should eql(expected) }
end
