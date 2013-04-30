# encoding: utf-8

require 'spec_helper'

describe Environment::Action, '.coerce' do

  subject { described_class.coerce(name, config) }

  let(:name)    { 'test' }
  let(:klass)   { Spec::Action::Success }
  let(:coerced) { Environment::Action.new(name.to_sym, klass, observers) }

  context "with an action and observers" do
    let(:config)    {
      {
        'action'    => 'Spec::Action::Success',
        'observers' => {
          'success' => [ 'Spec::Observer::Success' ],
          'failure' => [ 'Spec::Observer::Failure' ]
        }
      }
    }

    let(:observers) { Environment::Observers.new({
        :success => [ Spec::Observer::Success ],
        :failure => [ Spec::Observer::Failure ]
      })
    }

    it { should eql(coerced) }
  end

  context "with an action and no observers" do
    let(:config)    { { 'action' => 'Spec::Action::Success' } }
    let(:observers) { Environment::Observers.new({}) }

    it { should eql(coerced) }
  end

  context "with no action" do
    let(:config) { {} }

    specify {
      expect { subject }.to raise_error(KeyError)
    }
  end
end
