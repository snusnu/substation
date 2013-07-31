# encoding: utf-8

require 'spec_helper'

describe Environment, '#merge' do
  subject { object.merge(other) }

  let(:object)    { Environment.new(chain_dsl) }
  let(:chain_dsl) { Chain::DSL.build(registry) }
  let(:registry)  { described_class::DSL.new(&block).registry }
  let(:block)     {
    ->(_) {
      register(:test_1, Spec::Processor)
      register(:test_2, Spec::Processor)
    }
  }

  let(:other)           { Environment.new(other_chain_dsl) }
  let(:other_chain_dsl) { Chain::DSL.build(other_registry) }
  let(:other_registry)  { described_class::DSL.new(&other_block).registry }
  let(:other_block)     {
    ->(_) {
      register(:test_1, Spec::Processor)
      register(:test_3, Spec::Processor)
    }
  }

  let(:expected)           { Environment.new(expected_chain_dsl) }
  let(:expected_chain_dsl) { Chain::DSL.build(expected_registry) }
  let(:expected_registry)  { described_class::DSL.new(&expected_block).registry }
  let(:expected_block)     {
    ->(_) {
      register(:test_1, Spec::Processor)
      register(:test_2, Spec::Processor)
      register(:test_3, Spec::Processor)
    }
  }

  it { should eql(expected) }

  it 'should build a new chain dsl' do
    expect { subject.chain { test_1 Spec::FAKE_HANDLER } }.to_not raise_error
    expect { subject.chain { test_2 Spec::FAKE_HANDLER } }.to_not raise_error
    expect { subject.chain { test_3 Spec::FAKE_HANDLER } }.to_not raise_error
  end
end
