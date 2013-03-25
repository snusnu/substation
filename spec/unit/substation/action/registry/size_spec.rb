require 'spec_helper'

describe Action::Registry, '#size' do
  subject { object.size }

  context 'when an action is registered' do
    let(:object) { described_class.new(Set[action]) }
    let(:action) { mock }

    it { should == 1 }
  end

  context 'when no action is registered' do
    let(:object) { described_class.new }

    it { should == 0 }
  end
end
