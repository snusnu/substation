# encoding: utf-8

require 'spec_helper'

describe Environment::Observers, '.coerce' do

  subject { described_class.coerce(config) }

  let(:config)    {
    {
      'success' => [ 'Spec::Observer::Success' ],
      'failure' => [ 'Spec::Observer::Failure' ]
    }
  }

  let(:coerced) { Environment::Observers.new({
      :success => [ Spec::Observer::Success ],
      :failure => [ Spec::Observer::Failure ]
    })
  }

  it { should eql(coerced) }
end
