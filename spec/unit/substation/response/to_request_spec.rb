# encoding: utf-8

require 'spec_helper'

describe Response, '#to_request' do

  include_context 'Request#initialize'

  let(:object)   { Class.new(described_class).new(request, output) }
  let(:output)   { double('output') }
  let(:response) { Request.new(name, env, new_input) }

  context 'when no new input is given' do
    subject { object.to_request }

    let(:new_input) { output }

    it { should eql(response) }
  end

  context 'when new input is given' do
    subject { object.to_request(new_input) }

    let(:new_input) { double('new_input') }

    it { should eql(response) }
  end
end
