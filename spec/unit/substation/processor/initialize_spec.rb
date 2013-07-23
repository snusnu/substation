# encoding: utf-8

require 'spec_helper'

describe Processor, '#initialize' do

  subject { klass.new(processor_name, processor_config) }

  include_context 'Processor#initialize'

  let(:klass) {
    Class.new {
      include Substation::Processor
    }
  }

  its(:name)   { should eql(processor_name) }
  its(:config) { should eql(processor_config) }
end
