# encoding: utf-8

require 'spec_helper'

describe Environment::Action, '#call' do

  subject { object.call(request) }

  let(:object)   { described_class.new(klass, observer) }
  let(:klass)    { mock }
  let(:observer) { mock }
  let(:request)  { Request.new(env, input) }
  let(:env)      { mock }
  let(:input)    { mock }
  let(:response) { mock }

  before do
    klass.should_receive(:call).with(request).and_return(response)
    observer.should_receive(:call).with(response)
  end

  it { should eql(response) }
end
