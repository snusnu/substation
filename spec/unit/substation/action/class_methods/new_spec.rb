# encoding: utf-8

require 'spec_helper'

describe Action, '.new' do
  subject { object.new(request) }

  let(:request) { mock }

  it_should_behave_like 'an abstract type'
end
