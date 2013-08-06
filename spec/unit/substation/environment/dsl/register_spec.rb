# encoding: utf-8

require 'spec_helper'

describe Environment::DSL, '#register' do
  subject { object.register(name, processor) }

  let(:object)    { described_class.new(registry) }
  let(:registry)  { DSL::Registry.new(guard) }
  let(:guard)     { described_class::GUARD }
  let(:processor) { Spec::Processor }

  let(:expected) {
    DSL::Registry.new(guard, {
      :test => Processor::Builder.new(:test, Spec::Processor, Processor::Executor::NULL)
    })
  }

  context 'when the given name is valid' do

    share_examples_for 'name is valid' do
      its(:registry) { should eql(expected) }

      it_behaves_like 'a command method'
    end

    context 'and the name is given as a Symbol' do
      it_behaves_like 'name is valid' do
        let(:name) { :test }
      end
    end

    context 'and the name is given as a String' do
      it_behaves_like 'name is valid' do
        let(:name) { 'test' }
      end
    end

  end

  context 'when the given name is reserved' do
    let(:name) { Chain::DSL::BASE_METHODS.first }
    let(:msg)  { DSL::Guard::RESERVED_NAME_MSG % name.inspect }

    it 'raises ReservedNameError' do
      expect { subject }.to raise_error(ReservedNameError, msg)
    end
  end

  context 'when the given name is already registered' do
    let(:name) { :test }
    let(:msg)  { DSL::Guard::ALREADY_REGISTERED_MSG % name.inspect }

    before do
      object.register(name, processor)
    end

    it 'raises ReservedNameError' do
      expect { subject }.to raise_error(AlreadyRegisteredError, msg)
    end
  end
end
