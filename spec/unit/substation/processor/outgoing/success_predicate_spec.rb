# encoding: utf-8

require 'spec_helper'

describe Processor::Outgoing, '#success?' do
  subject { object.success?(response) }

  let(:object)   { klass.new(name, handler) }
  let(:klass)    { Class.new { include Processor::Outgoing } }
  let(:name)     { mock }
  let(:handler)  { mock }
  let(:response) { mock }

  it { should be(true) }
end
