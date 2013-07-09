# encoding: utf-8

require 'spec_helper'

describe Chain, '.failure_response' do
  subject { described_class.failure_response(request, data, exception) }

  let(:request)   { mock(:env => mock, :input => mock) }
  let(:data)      { mock }
  let(:exception) { mock }

  let(:expected)     { Response::Failure.new(request, failure_data) }
  let(:failure_data) { described_class::FailureData.new(data, exception) }

  it { should eql(expected) }
end
