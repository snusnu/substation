# encoding: utf-8

require 'spec_helper'

describe Response::API::Failure, '#success?' do
  subject { object.success? }

  let(:object) { Class.new { include Response::API::Failure }.new }

  it { should be(false) }
end
