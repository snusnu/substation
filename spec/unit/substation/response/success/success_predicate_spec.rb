# encoding: utf-8

require 'spec_helper'

describe Response::Success, '#success?' do
  subject { object.success? }

  let(:object)  { described_class.new(request, output) }
  let(:request) { Request.new(env, input) }
  let(:env)     { mock }
  let(:input)   { mock }
  let(:output)  { mock }

  it { should be(true) }
end
