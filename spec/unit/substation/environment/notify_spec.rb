# encoding: utf-8

require 'spec_helper'

describe Environment, '#notify' do

  subject { object.notify(event) }

  let(:object)    { described_class.new(config) }
  let(:name)      { :test }
  let(:config)    { { name  => action } }
  let(:action)    { Environment::Action.new(name, Spec::Action::Success, observers) }
  let(:observers) { Environment::Observers.new(:success => [ observer ] ) }
  let(:observer)  { mock }
  let(:event)     { mock(:action_name => name, :kind => :success) }

  before do
    observer.should_receive(:call).with(event).once
  end

  it { should eql(object) }
end
