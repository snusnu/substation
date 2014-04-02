# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator::Result do
  describe '.new' do
    subject { object.new(output) }

    let(:output) { double }

    it_behaves_like 'an abstract type'
  end
end
