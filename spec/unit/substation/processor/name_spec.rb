# encoding: utf-8

require 'spec_helper'

describe Processor, '#name' do
  subject { object.name }

  let(:object)  { klass.new(name, handler) }
  let(:klass)   { Class.new { include Processor } }
  let(:name)    { mock }
  let(:handler) { mock }

  it { should be(name) }
end
