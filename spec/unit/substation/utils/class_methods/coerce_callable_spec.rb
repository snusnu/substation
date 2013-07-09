# encoding: utf-8

require 'spec_helper'

describe Utils, '.coerce_callable' do

  subject { described_class.coerce_callable(handler) }

  let(:const) { Spec::Action::Success }

  context 'with a String handler' do
    let(:handler) { const.name }

    it { should be(Spec::Action::Success) }
  end

  context 'with a Symbol handler' do
    let(:handler) { const.name.to_sym }

    it { should be(Spec::Action::Success) }
  end

  context 'with a const handler' do
    let(:handler) { const }

    it { should be(const) }
  end

  context 'with a Proc handler' do
    let(:handler) { ->(response) { response } }

    it { should be(handler) }
  end

  context 'with a Chain handler' do
    let(:handler) { Chain.new([]) }

    it { should be(handler) }
  end

  context 'with an unsupported handler' do
    let(:handler) { mock }

    specify do
      expect { subject }.to raise_error(ArgumentError)
    end
  end
end
