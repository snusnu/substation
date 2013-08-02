# encoding: utf-8

require 'spec_helper'

describe Chain, '.exception_response' do
  subject { described_class.exception_response(request, data, exception) }

  include_context 'Request#initialize'

  let(:data)      { double('data') }
  let(:exception) { double('exception') }

  let(:expected)         { Response::Exception.new(expected_request, failure_data) }
  let(:expected_request) { request.with_input(data) }
  let(:failure_data)     { Response::Exception::Output.new(data, exception) }

  it { should eql(expected) }
end
