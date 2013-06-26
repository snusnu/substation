# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator, '.new' do
  subject { object.new }

  it_behaves_like 'an abstract type'
end
