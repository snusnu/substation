# encoding: utf-8

require 'spec_helper'

describe Action::Response::Success, '#success?' do
  subject { object.success? }

  let(:object) { described_class.new(data) }
  let(:data)   { mock }

  it { should be(true) }
end
