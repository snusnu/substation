# encoding: utf-8

require 'spec_helper'

describe Request, '#name' do
  subject { request.name }

  include_context 'Request#initialize'

  it { should be(name) }
end
