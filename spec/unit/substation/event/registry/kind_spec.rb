# encoding: utf-8

require 'spec_helper'

describe Event::Registry, '#kind' do

  subject { object.kind(event_class) }

  let(:object)      { described_class.new }
  let(:kind)        { :test }
  let(:event_class) { mock }

  before do
    object.register(kind, event_class)
  end

  it { should be(kind) }
end
