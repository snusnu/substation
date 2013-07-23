# encoding: utf-8

require 'spec_helper'

describe Processor::Outgoing, '#success?' do
  subject { object.success?(response) }

  include_context 'Processor#initialize'

  let(:klass)    { Class.new { include Substation::Processor::Outgoing } }
  let(:response) { double }

  it { should be(true) }
end
