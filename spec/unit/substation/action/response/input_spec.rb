# encoding: utf-8

require 'spec_helper'

describe Action::Response, '#input' do

  subject { object.input }

  let(:object)   { Class.new(described_class).new(request, data) }
  let(:request)  { mock(:actor => mock, :data => input) }
  let(:input)    { mock }
  let(:data)     { mock }

  it { should equal(input) }
end
