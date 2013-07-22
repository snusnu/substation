# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#executor' do
  subject { object.executor }

  include_context 'Processor::Config#initialize'

  it { should be(executor) }
end
