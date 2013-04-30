# encoding: utf-8

require 'spec_helper'

describe Action, '#actor' do

  subject { object.actor }

  let(:object)   { Spec::Action.new(name, request, env) }
  let(:name)     { mock }
  let(:request)  { mock(:actor => actor, :data => mock) }
  let(:actor)    { mock }
  let(:env)      { mock }

  it { should equal(actor) }
end
