# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#observers' do
  subject { processor_config.observers }

  include_context 'Processor::Config#initialize'

  it { should be(observers) }
end
