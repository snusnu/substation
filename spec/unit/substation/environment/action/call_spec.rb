# encoding: utf-8

require 'spec_helper'

describe Environment::Action, '#call' do

  subject { object.call(name, request, env) }

  let(:object)   { described_class.new( klass, observer) }
  let(:name)     { mock('Name')                          }
  let(:klass)    { mock('Class')                         }
  let(:observer) { mock('Observer')                      }
  let(:request)  { mock('Request')                       }
  let(:env)      { mock('Env')                           }
  let(:response) { mock('Response')                      }

  before do
    klass.should_receive(:call).with(name, request, env).and_return(response)
    observer.should_receive(:call).with(response)
  end

  it { should eql(response) }
end
