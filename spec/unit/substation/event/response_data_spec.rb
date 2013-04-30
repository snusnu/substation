# encoding: utf-8

require 'spec_helper'

describe Event, '#response_data' do

  subject { object.response_data }

  let(:object) do
    Class.new(described_class) {
      register_as :test
    }.new(action, date, response_data)
  end

  let(:action)        { mock(:name => mock, :actor => mock, :data => mock) }
  let(:date)          { mock }
  let(:response_data) { mock }

  it { should be(response_data) }
end
