# encoding: utf-8

require 'spec_helper'

describe Action::Response, '#data' do

  subject { object.data }

  let(:object)   { Class.new(described_class).new(request, data) }
  let(:request)  { mock(:actor => mock, :data => mock) }
  let(:data)     { mock }

  it { should equal(data) }
end
