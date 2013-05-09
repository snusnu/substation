# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '#action_names' do

  subject { object.action_names }

  let(:object) { described_class.new(config) }
  let(:config) { { :test => { :action => Spec::Action::Success } } }

  it { should eql(Set[ :test ]) }
end
