# encoding: utf-8

require 'spec_helper'

describe Environment::DSL::Guard, '#call' do
  subject { object.call(name, registry) }

  let(:name)     { double('name') }
  let(:registry) { double('registry') }

  context 'when no reserved names are given' do
    let(:object) { described_class.new }

    context 'when the given name is valid' do
      let(:name) { :test }

      before do
        expect(registry).to receive(:include?).with(name).and_return(false)
      end

      it 'raises no error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'when the given name is already registered' do
      let(:name) { :test }
      let(:msg)  { described_class::ALREADY_REGISTERED_MSG % name.inspect }

      before do
        expect(registry).to receive(:include?).with(name).and_return(true)
      end

      it 'raises ReservedNameError' do
        expect { subject }.to raise_error(AlreadyRegisteredError, msg)
      end
    end
  end

  context 'when reserved names are given' do
    let(:object)         { described_class.new(reserved_names) }
    let(:reserved_names) { double('reserved_names') }

    before do
      expect(registry).to receive(:include?).with(name).and_return(false)
    end

    context 'when the given name is not reserved' do
      before do
        expect(reserved_names).to receive(:include?).with(name).and_return(false)
      end

      it 'raises no error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'when the given name is reserved' do
      let(:msg)  { described_class::RESERVED_NAME_MSG % name.inspect }

      before do
        expect(reserved_names).to receive(:include?).with(name).and_return(true)
      end

      it 'raises ReservedNameError' do
        expect { subject }.to raise_error(ReservedNameError, msg)
      end
    end
  end
end
