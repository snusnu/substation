# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator::Result, '.new' do
  subject { object.new(output) }

  let(:output) { mock }

  it_behaves_like 'an abstract type'
end
