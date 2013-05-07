# encoding: utf-8

require 'spec_helper'

describe Response, '#actor' do

  subject { object.actor }

  let(:object)   { Class.new(described_class).new(request, data) }
  let(:request)  { mock(:actor => actor, :data => mock) }
  let(:actor)    { mock }
  let(:data)     { mock }

  it { should equal(actor) }
end
