# encoding: utf-8

require 'spec_helper'

describe Response::Success, '#success?' do
  subject { object.success? }

  let(:object)  { described_class.new(request, data) }
  let(:request) { mock(:actor => mock, :data => mock) }
  let(:data)    { mock }

  it { should be(true) }
end
