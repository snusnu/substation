# encoding: utf-8

require 'spec_helper'

describe Processor::Outgoing, '#name' do
  subject { object.name }

  include_context 'Processor#initialize'

  let(:klass) { Class.new { include Substation::Processor::Outgoing } }

  it { should be(processor_name) }
end
