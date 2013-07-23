# encoding: utf-8

require 'spec_helper'

describe Response, '#output' do
  subject { object.output }

  include_context 'Request#initialize'

  let(:object) { Class.new(described_class).new(request, output) }
  let(:output) { double }

  it { should equal(output) }
end
