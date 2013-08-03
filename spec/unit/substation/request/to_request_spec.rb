# encoding: utf-8

require 'spec_helper'

describe Request, '#to_request' do
  include_context 'Request#initialize'

  let(:object) { request }

  context 'when no input is given' do
    subject { object.to_request }

    it { should be(object) }
  end

  context 'when input is given' do
    subject { object.to_request(new_input) }

    let(:expected)  { described_class.new(name, env, new_input) }
    let(:new_input) { double('new_input') }

    it { should eql(expected) }
  end
end
