# encoding: utf-8

require 'spec_helper'

describe Environment::Action, '.coerce' do

  subject { described_class.coerce(config) }

  let(:klass)   { Spec::Action::Success }
  let(:coerced) { Environment::Action.new(klass, observer) }

  context 'with an action and observer' do
    let(:config) do
      {
        'action'   => 'Spec::Action::Success',
        'observer' => 'Spec::Observer'
      }
    end

    let(:observer) { Spec::Observer }

    it { should eql(coerced) }
  end

  context 'with an action and no observer' do
    let(:config)   { { 'action' => 'Spec::Action::Success' } }
    let(:observer) { Observer::Null                          }

    it { should eql(coerced) }
  end

  context 'with no action' do
    let(:config) { {} }

    specify {
      expect { subject }.to raise_error(described_class::MissingClassError)
    }
  end
end
