# encoding: utf-8

require 'spec_helper'

describe Response::Failure, '#success?' do
  subject { object.success? }

  let(:object)  { described_class.new(request, output) }
  let(:request) { Request.new(name, env, input) }
  let(:name)    { double }
  let(:env)     { double }
  let(:input)   { double }
  let(:output)  { double }
end
