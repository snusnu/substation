# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator::Pivot, '#call' do
  it_behaves_like 'Processor::Evaluator#call' do
    let(:klass) { described_class }
  end
end
