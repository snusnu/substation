# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '.coerce' do

  subject { described_class.coerce(config) }

  let(:name)     { 'test'                                               }
  let(:config)   { { name => action }                                   }
  let(:action)   { { 'action' => 'Spec::Action::Success' }              }
  let(:observer) { Observer::NOOP                                       }
  let(:coerced)  { { :test  => described_class::Action.coerce(action) } }

  it { should eql(described_class.new(coerced)) }
end
