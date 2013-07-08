# encoding: utf-8

require 'spec_helper'

describe Processor::Fallible, '#with_failure_chain' do
  subject { object.with_failure_chain(chain) }

  let(:object)        { klass.new(name, handler, failure_chain) }
  let(:klass)         { Class.new { include Processor::Fallible } }
  let(:name)          { mock }
  let(:handler)       { mock }
  let(:failure_chain) { mock }
  let(:chain)         { mock }

  let(:expected) { klass.new(name, handler, chain) }

  it { should eql(expected) }
end
