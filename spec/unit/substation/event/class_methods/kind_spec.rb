# encoding: utf-8

require 'spec_helper'

describe Event, '.kind' do

  subject { object.kind }

  let(:object) { Class.new(described_class) }
  let(:kind)   { :test }

  before do
    object.register_as(kind)
  end

  it { should be(kind) }
end
