# encoding: utf-8

require 'spec_helper'

describe Response, '#env' do
  let(:object) { Class.new(described_class).new(request, output) }
  let(:output) { double }

  describe '#env' do
    subject { object.env }

    include_context 'Request#initialize'

    it { should be(env) }
  end

  describe Response::Failure, '#exception?' do
    subject { object.exception? }

    include_context 'Request#initialize'

    it { should be(false) }
  end

  describe '#input' do
    subject { object.input }

    include_context 'Request#initialize'

    it { should be(input) }
  end

  describe '#output' do
    subject { object.output }

    include_context 'Request#initialize'

    it { should equal(output) }
  end

  describe '#request' do
    subject { object.request }

    include_context 'Request#initialize'

    it { should be(request) }
  end

  describe '#to_request' do

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
end
