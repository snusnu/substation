# encoding: utf-8

require 'spec_helper'

describe Request, '#input' do
  subject { request.input }

  include_context 'Request#initialize'

  it { should be(input) }
end
