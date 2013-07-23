# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '#action_names' do

  subject { object.action_names }

  let(:object) { described_class.new(config, env) }
  let(:config) { { :test => { :action => Spec::Action::Success } } }
  let(:env)    { double }

  it { should eql(Set[ :test ]) }
end
