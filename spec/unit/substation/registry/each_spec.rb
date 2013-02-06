# encoding: utf-8

require 'spec_helper'

describe Registry, '#each' do
  subject { object.each { |action| yields << action } }

  let(:object) { described_class.new(Set[action]) }
  let(:action) { mock }
  let(:yields) { [] }

  before do
    object.should be_instance_of(described_class)
  end

  it_should_behave_like 'an #each method'

  it 'yields the expected values' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to([ action ])
  end
end

describe Registry do
  subject { object.new }

  let(:object) { described_class }

  before do
    subject.should be_instance_of(object)
  end

  it { should be_kind_of(Enumerable) }

  it 'case matches Enumerable' do
    (Enumerable === subject).should be(true)
  end
end
