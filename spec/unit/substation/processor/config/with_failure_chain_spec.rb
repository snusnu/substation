# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#with_failure_chain' do
  subject { object.with_failure_chain(failure_chain) }

  include_context 'Processor::Config#initialize'

  it { should eql(object) }
end
