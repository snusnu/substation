# encoding: utf-8

require 'spec_helper'

describe Processor::Incoming, '#result' do
  subject { object.result(response) }

  include_context 'Request#initialize'
  include_context 'Processor#initialize'

  let(:klass) { Class.new { include Substation::Processor::Incoming } }
  let(:response) { Response::Success.new(request, input) }

  it { should eql(request) }
end
