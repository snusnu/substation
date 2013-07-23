# encoding: utf-8

require 'spec_helper'

describe Response::API::Success, '#success?' do
  subject { object.success? }

  let(:object) { Class.new { include Response::API::Success }.new }

  it { should be(true) }
end
