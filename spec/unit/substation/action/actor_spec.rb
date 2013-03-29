# encoding: utf-8

require 'spec_helper'

describe Action, '#actor' do

  subject { object.actor }

  let(:object) do
    Class.new(described_class).new(request)
  end

  let(:request) { mock(:actor => actor, :data => data) }
  let(:actor)   { mock }
  let(:data)    { mock }

  it { should equal(actor) }
end
