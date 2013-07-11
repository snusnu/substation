# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator::Handler, '#success' do
  subject { object.success(output) }

  let(:object) { Class.new { include Processor::Evaluator::Handler }.new }
  let(:output) { mock }

  it { should eql(Processor::Evaluator::Result::Success.new(output)) }
end
