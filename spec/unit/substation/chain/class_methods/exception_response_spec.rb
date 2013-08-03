# encoding: utf-8

require 'spec_helper'

describe Chain, '.exception_response' do
  subject { described_class.exception_response(state, data, exception) }

  include_context 'Request#initialize'

  let(:data)           { double('data') }
  let(:exception)      { double('exception') }
  let(:exception_data) { Response::Exception::Output.new(data, exception) }

  let(:expected)         { Response::Exception.new(expected_request, exception_data) }

  context 'when a request is passed as current state' do
    let(:state)            { request }
    let(:expected_request) { request.to_request(data) }

    it { should eql(expected) }
  end

  context 'when a response is passed as current state' do
    let(:state)            { response }
    let(:expected_request) { response.to_request(data) }
    let(:response)         { Response::Failure.new(request, output) }
    let(:output)           { double('output') }

    it { should eql(expected) }
  end
end
