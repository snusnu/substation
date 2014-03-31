# encoding: utf-8

require 'spec_helper'

describe Chain::DSL do
  describe '#build' do
    include_context 'Chain::DSL#initialize'

    let(:failure_chain)       { Chain::EMPTY }
    let(:block)               { ->(_) { test(Spec::FAKE_HANDLER) } }
    let(:expected_definition) { Chain::Definition.new(chain_name, expected_processors) }
    let(:expected)            { Chain.new(expected_definition, failure_chain) }

    let(:new_processors)      { [new_processor] }
    let(:new_processor)       { double('new_processor', :name => :new_processor) }

    shared_examples_for 'duplicate processors' do
      let(:new_processor) { processor }
      let(:msg)           { Chain::Definition::DUPLICATE_PROCESSOR_MSG % [processor].inspect }

      it 'should raise DuplicateProcessorError' do
        expect { subject }.to raise_error(DuplicateProcessorError, msg)
      end
    end

    shared_examples_for 'disjoint processors' do
      it { should eql(expected) }

      it 'injects the proper registry' do
        expect(chain_dsl.registry).to be(registry)
      end
    end

    context 'when a block is given' do
      subject { chain_dsl.build(chain_name, new_processors, failure_chain, &block) }

      context 'and all processors are disjoint' do
        let(:expected_processors) { [processor, new_processor, Spec::FAKE_PROCESSOR] }

        it_behaves_like 'disjoint processors'
      end

      context 'and there are duplicate processors' do
        it_behaves_like 'duplicate processors'
      end
    end

    context 'when no block is given' do
      subject { chain_dsl.build(chain_name, new_processors, failure_chain) }

      context 'and all processors are disjoint' do
        let(:expected_processors) { [processor, new_processor] }

        it_behaves_like 'disjoint processors'
      end

      context 'and there are duplicate processors' do
        it_behaves_like 'duplicate processors'
      end
    end
  end

  describe '#chain' do
    subject { object.chain(other_processors) }

    let(:object)     { described_class.new(config, definition) }
    let(:config)     { Chain::DSL::Config.new(registry, dsl_module) }
    let(:registry)   { double('registry') }
    let(:dsl_module) { Module.new }
    let(:name)       { double('name') }

    let(:definition) { Chain::Definition.new(name, processors) }
    let(:processors) { [processor] }
    let(:processor)  { double('processor', :name => :processor) }

    let(:other_definition) { Chain::Definition.new(name, other_processors) }
    let(:other_processors) { [other_processor] }
    let(:other_processor)  { double('other_processor', :name => :other_processor) }

    let(:expected)            { described_class.new(config, expected_definition) }
    let(:expected_definition) { other_definition.prepend(definition) }

    it { should eql(expected) }
  end

  describe '#definition' do
    subject { object.definition }

    include_context 'Chain::DSL#initialize'

    let(:object) { chain_dsl }

    it { should eql(definition) }
  end

  describe '#failure_chain' do
    subject { object.failure_chain(name, failure_chain) }

    let(:object)        { described_class.new(config, definition) }
    let(:config)        { Chain::DSL::Config.new(registry, dsl_module) }
    let(:registry)      { double('registry') }
    let(:dsl_module)    { Module.new }
    let(:definition)    { double('definition', :name => double('chain_name')) }
    let(:name)          { double('name') }
    let(:failure_chain) { double('failure_chain') }

    before do
      expect(definition).to receive(:replace_failure_chain).with(name, failure_chain)
    end

    it_behaves_like 'a command method'
  end

  describe '.build' do

    let(:registry)   { double('registry') }
    let(:dsl)        { double('dsl') }
    let(:config)     { double('config') }
    let(:definition) { double('definition') }

    before do
      expect(Chain::DSL::Config).to receive(:build).with(registry).and_return(config)
      expect(described_class).to receive(:new).with(config, definition).and_return(dsl)
    end

    context 'when a definition is given' do
      subject { described_class.build(registry, definition) }

      it { should be(dsl) }
    end

    context 'when no definition is given' do
      subject { described_class.build(registry) }

      let(:definition) { Chain::Definition::EMPTY }

      it { should be(dsl) }
    end
  end
end
