# encoding: utf-8

require 'spec_helper'

describe Action, '#name' do

  subject { object.name }

  let(:object)   { Spec::Action.new(name, request, env) }
  let(:name)     { mock }
  let(:request)  { mock(:actor => mock, :data => mock) }
  let(:env)      { mock }

  it { should equal(name) }
end
