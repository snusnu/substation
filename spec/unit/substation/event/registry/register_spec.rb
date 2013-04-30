# encoding: utf-8

require 'spec_helper'

describe Event::Registry, '#register' do

  subject { object.register(kind, event_class) }

  let(:object)      { described_class.new }
  let(:kind)        { :test }
  let(:event_class) { mock }

  it "should register event_class under the given kind"do
    subject.kind(event_class).should be(kind)
  end
end
