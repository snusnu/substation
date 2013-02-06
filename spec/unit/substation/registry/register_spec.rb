require 'spec_helper'

describe Substation::Registry, '#register' do
  subject { object.register(action) }

  let(:action) { mock }

  context 'when the action is not yet registered' do
    let(:object) { described_class.new }

    it_behaves_like 'a command method'

    its(:size) { should == 1 }

    it { should include(action) }
  end

  context 'when the action is already registered' do
    let(:object) { described_class.new(Set[action]) }

    it_behaves_like 'a command method'

    its(:size) { should == 1 }

    it { should include(action) }
  end
end
