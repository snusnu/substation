# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator, '#call' do
  it_behaves_like 'Processor::Evaluator#call' do
    let(:klass) { Class.new(described_class) { include Processor::Incoming } }
  end
end
