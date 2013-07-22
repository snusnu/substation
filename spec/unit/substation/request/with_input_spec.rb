# encoding: utf-8

require 'spec_helper'

describe Request, '#with_input' do
  subject { request.with_input(data) }

  include_context 'Request#initialize'

  let(:data) { double }

  it { should eql(Request.new(name, env, data)) }
end
