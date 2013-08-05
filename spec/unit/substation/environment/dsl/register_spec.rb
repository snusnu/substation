# encoding: utf-8

require 'spec_helper'

describe Environment::DSL, '#register' do
  subject { object.register(name, processor) }

  let(:object)    { described_class.new(guard) }
  let(:guard)     { described_class::GUARD }
  let(:processor) { Spec::Processor }

  let(:expected) {
    {
      :test => Processor::Builder.new(:test, Spec::Processor, Processor::Executor::NULL)
    }
  }

  context 'when the given name is valid' do

    share_examples_for 'name is valid' do
      it 'registers the given processor' do
        expect(subject.registry).to eql(expected)
      end

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
    let(:msg)  { described_class::Guard::RESERVED_NAME_MSG % name.inspect }

    it 'raises ReservedNameError' do
      expect { subject }.to raise_error(ReservedNameError, msg)
    end
  end

  context 'when the given name is already registered' do
    let(:name) { :test }
    let(:msg)  { described_class::Guard::ALREADY_REGISTERED_MSG % name.inspect }

    before do
      object.register(name, processor)
    end

    it 'raises ReservedNameError' do
      expect { subject }.to raise_error(AlreadyRegisteredError, msg)
    end
  end
end
