# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator::Handler do
  let(:object) { Class.new { include Processor::Evaluator::Handler }.new }
  let(:output) { double }

  describe '#error' do
    subject { object.error(output) }

    it { should eql(Processor::Evaluator::Result::Failure.new(output)) }
  end

  describe '#success' do
    subject { object.success(output) }

    it { should eql(Processor::Evaluator::Result::Success.new(output)) }
  end
end
