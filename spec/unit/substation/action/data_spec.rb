# encoding: utf-8

require 'spec_helper'

describe Action, '#data' do

  subject { object.data }

  let(:object)   { Spec::Action.new(name, request, env) }
  let(:name)     { :test }
  let(:request)  { mock(:actor => mock, :data => data) }
  let(:data)     { mock }
  let(:env)      { mock }

  it { should equal(data) }
end
