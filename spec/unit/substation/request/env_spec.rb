# encoding: utf-8

require 'spec_helper'

describe Request, '#env' do
  subject { request.env }

  include_context 'Request#initialize'

  it { should be(env) }
end
