# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#failure_chain' do
  subject { processor_config.failure_chain }

  include_context 'Processor::Config#initialize'

  it { should be(failure_chain) }
end
