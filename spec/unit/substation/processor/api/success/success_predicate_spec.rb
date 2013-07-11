# encoding: utf-8

require 'spec_helper'

describe Processor::API::Success, '#success?' do
  subject { object.success? }

  let(:object)  { Class.new { include Processor::API::Success }.new }

  it { should be(true) }
end
