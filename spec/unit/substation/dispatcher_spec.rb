# encoding: utf-8

require 'spec_helper'

describe Dispatcher do
  describe '#call' do

    subject { object.call(name, input) }

    include_context 'Request#initialize'

    let(:object)  { described_class.new(config, env) }
    let(:config)  { DSL::Registry.new(guard, :test => Spec::Action::Success) }
    let(:guard)   { double('guard') }

    let(:expected_response) do
      Spec::Action::Success.call(request)
    end

    context 'when the action is registered' do
      let(:name) { :test }

      it { should eql(expected_response) }
    end

    context 'when the action is not registered' do
      let(:name) { :unknown }
      let(:msg)  { UnknownActionError.msg(name) }

      specify do
        expect { subject }.to raise_error(UnknownActionError, msg)
      end
    end
  end

  describe '.new_registry' do
    subject { described_class.new_registry }

    let(:expected) { DSL::Registry.new(described_class::GUARD) }

    it { should eql(expected) }
  end

  describe '#include?' do

    subject { object.include?(name) }

    let(:object)  { described_class.new(actions, env) }
    let(:actions) { Hash[action => double('action')] }
    let(:action)  { double('action') }
    let(:env)     { double('env') }

    context 'when the action is registered' do
      let(:name) { action }

      it 'returns true' do
        expect(subject).to be(true)
      end
    end

    context 'when the action is not registered' do
      let(:name) { :unknown }

      it 'returns false' do
        expect(subject).to be(false)
      end
    end
  end
end
