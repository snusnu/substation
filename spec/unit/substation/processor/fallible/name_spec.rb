# encoding: utf-8

require 'spec_helper'

describe Processor::Fallible, '#name' do
  subject { object.name }

  let(:object)        { klass.new(name, handler, failure_chain) }
  let(:klass)         { Class.new { include Processor::Fallible } }
  let(:name)          { mock }
  let(:handler)       { mock }
  let(:failure_chain) { mock }

  it { should be(name) }
end
