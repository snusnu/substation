# encoding: utf-8

require 'spec_helper'

describe Environment::Action, '#call' do

  subject { object.call(name, request, env) }

  let(:object)    { described_class.new(name, klass, observers) }
  let(:name)      { mock }
  let(:klass)     { mock }
  let(:observers) { mock }
  let(:request)   { mock }
  let(:env)       { mock }
  let(:response)  { mock }

  before do
    klass.should_receive(:call).with(name, request, env).and_return(response)
  end

  it { should eql(response) }
end
