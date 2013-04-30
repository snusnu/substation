# encoding: utf-8

require 'spec_helper'

describe Event, '#request_data' do

  subject { object.request_data }

  let(:object) do
    Class.new(described_class) {
      register_as :test
    }.new(action, date, response_data)
  end

  let(:action)        { mock(:name => mock, :actor => mock, :data => request_data) }
  let(:request_data)  { mock }
  let(:date)          { mock }
  let(:response_data) { mock }

  it { should be(request_data) }
end
