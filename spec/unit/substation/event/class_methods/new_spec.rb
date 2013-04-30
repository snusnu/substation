# encoding: utf-8

require 'spec_helper'

describe Event, '.new' do
  subject { object.new(action, date, response_data) }

  let(:action)        { mock(:name => mock, :actor => mock, :data => mock) }
  let(:date)          { mock }
  let(:response_data) { mock }

  it_should_behave_like 'an abstract type'
end
