# encoding: utf-8

require 'spec_helper'

describe Environment::Observers, '#notify' do

  subject { object.notify(event) }

  context "when an observer is registered" do
    let(:object)   { described_class.new(:success => [ observer ] ) }
    let(:observer) { mock }
    let(:event)    { mock(:action_name => mock, :kind => :success) }

    before do
      observer.should_receive(:call).with(event).once
    end

    it { should eql(object) }
  end

  context "when no observer is registered" do
    let(:object)   { described_class.new(:success => [ observer ] ) }
    let(:observer) { mock }
    let(:event)    { mock(:action_name => mock, :kind => :failure) }

    before do
      observer.should_not_receive(:call).with(event)
    end

    it { should eql(object) }
  end
end
