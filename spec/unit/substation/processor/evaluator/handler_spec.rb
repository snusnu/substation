# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator::Handler do
  describe '#error' do
    subject { object.error(output) }

    let(:object) { Class.new { include Processor::Evaluator::Handler }.new }
    let(:output) { double }

    it { should eql(Processor::Evaluator::Result::Failure.new(output)) }
  end

  describe '#success' do
    subject { object.success(output) }

    let(:object) { Class.new { include Processor::Evaluator::Handler }.new }
    let(:output) { double }

    it { should eql(Processor::Evaluator::Result::Success.new(output)) }
  end
end
