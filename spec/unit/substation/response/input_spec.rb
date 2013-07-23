# encoding: utf-8

require 'spec_helper'

describe Response, '#input' do
  subject { object.input }

  include_context 'Request#initialize'

  let(:object) { Class.new(described_class).new(request, output) }
  let(:output) { double }

  it { should be(input) }
end
