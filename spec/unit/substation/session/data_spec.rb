require 'spec_helper'

describe Session, '#actor' do
  subject { object.data }

  let(:object) { described_class.new(actor, data) }
  let(:actor)  { mock }
  let(:data)   { mock }

  it { should equal(data) }
end
