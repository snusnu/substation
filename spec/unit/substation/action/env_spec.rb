# encoding: utf-8

require 'spec_helper'

describe Action, '#env' do

  subject { object.env }

  let(:object)   { Spec::Action.new(name, request, env) }
  let(:name)     { mock }
  let(:request)  { mock(:actor => mock, :data => mock) }
  let(:env)      { mock }


  it { should equal(env) }
end
