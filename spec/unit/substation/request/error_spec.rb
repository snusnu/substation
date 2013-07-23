# encoding: utf-8

require 'spec_helper'

describe Request, '#error' do
  subject { request.error(output) }

  include_context 'Request#initialize'

  let(:output) { double }

  it { should eql(Response::Failure.new(request, output)) }
end
