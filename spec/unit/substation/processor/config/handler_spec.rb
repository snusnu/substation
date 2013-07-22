# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#handler' do
  subject { config.handler }

  include_context 'Processor::Config#initialize'

  it { should be(handler) }
end
