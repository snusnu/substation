# encoding: utf-8

require 'spec_helper'

describe Environment::Action, '#notify' do

  subject { object.notify(event) }

  let(:object)    { described_class.new(name, klass, observers) }
  let(:name)      { :test }
  let(:klass)     { Spec::Action::Success }
  let(:observers) { Environment::Observers.new(:success => [ observer ] ) }
  let(:observer)  { mock }
  let(:event)     { mock(:action_name => name, :kind => :success) }

  before do
    observer.should_receive(:call).with(event).once
  end

  it { should eql(object) }
end
