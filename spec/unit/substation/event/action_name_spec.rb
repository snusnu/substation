# encoding: utf-8

require 'spec_helper'

describe Event, '#action_name' do

  subject { object.action_name }

  let(:object) do
    Class.new(described_class) {
      register_as :test
    }.new(action, date, response_data)
  end

  let(:action)        { mock(:name => action_name, :actor => mock, :data => mock) }
  let(:action_name)   { :test }
  let(:date)          { mock }
  let(:response_data) { mock }

  it { should be(action_name) }
end
