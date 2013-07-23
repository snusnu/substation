# encoding: utf-8

require 'spec_helper'

describe Response, '#to_request' do
  subject { object.to_request }

  include_context 'Request#initialize'

  let(:object)   { Class.new(described_class).new(request, output) }
  let(:output)   { double }
  let(:response) { Request.new(name, env, output) }

  it { should eql(response) }
end
