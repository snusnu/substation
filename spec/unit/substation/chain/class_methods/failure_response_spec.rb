# encoding: utf-8

require 'spec_helper'

describe Chain, '.failure_response' do
  subject { described_class.failure_response(request, data, exception) }

  include_context 'Request#initialize'

  let(:data)      { double('data') }
  let(:exception) { double('exception') }

  let(:expected)         { Response::Failure.new(expected_request, failure_data) }
  let(:expected_request) { request.with_input(data) }
  let(:failure_data)     { described_class::FailureData.new(data, exception) }

  it { should eql(expected) }
end
