require 'spec_helper'

describe Registry, '#include?' do
  subject { object.include?(action) }

  let(:action) { mock }

  context 'when the action is registered' do
    let(:object) { described_class.new(Set[action]) }

    it { should be(true) }
  end

  context 'when the action is not registered' do
    let(:object) { described_class.new }

    it { should be(false) }
  end
end
