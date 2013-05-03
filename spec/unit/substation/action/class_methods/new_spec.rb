# encoding: utf-8

require 'spec_helper'

describe Action, '.new' do
  subject { object.new(env, request) }

  let(:name)    { :test }
  let(:request) { mock(:actor => mock, :data => mock) }
  let(:env)     { Environment.new(name => { :action => mock }) }

  it_should_behave_like 'an abstract type'
end
