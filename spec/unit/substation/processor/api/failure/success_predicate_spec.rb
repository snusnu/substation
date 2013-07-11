# encoding: utf-8

require 'spec_helper'

describe Processor::API::Failure, '#success?' do
  subject { object.success? }

  let(:object)  { Class.new { include Processor::API::Failure }.new }

  it { should be(false) }
end
