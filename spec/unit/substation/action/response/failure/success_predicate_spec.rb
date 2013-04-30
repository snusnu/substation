# encoding: utf-8

require 'spec_helper'

describe Action::Response::Failure, '#success?' do
  subject { object.success? }

  let(:object) { described_class.new(error) }
  let(:error)  { mock }

  it { should be(false) }
end
