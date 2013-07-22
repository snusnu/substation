# encoding: utf-8

require 'spec_helper'

describe Request, '#success' do
  subject { request.success(output) }

  include_context 'Request#initialize'

  let(:output) { double }

  it { should eql(Response::Success.new(request, output)) }
end
