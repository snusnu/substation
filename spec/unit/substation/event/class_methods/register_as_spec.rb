# encoding: utf-8

require 'spec_helper'

describe Event, '.register_as' do

  subject { object.register_as(kind) }

  let(:object) { Class.new(described_class) }
  let(:kind)   { :test }

  it "should register its kind" do
    subject.kind.should be(kind)
  end
end
