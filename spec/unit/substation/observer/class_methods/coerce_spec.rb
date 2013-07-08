# encoding: utf-8

require 'spec_helper'

describe Observer, '.coerce' do

  subject { object.coerce(input) }

  let(:object) { described_class }

  context 'with nil input' do
    let(:input) { nil }

    it { should be(described_class::NULL) }
  end

  context 'with array input' do
    let(:input) { ['Spec::Observer', nil] }

    let(:observers) { [Spec::Observer, described_class::NULL] }

    it { should eql(described_class::Chain.new(observers)) }
  end

  context 'with other input' do
    let(:input)   { mock }
    let(:coerced) { mock }

    before do
      Utils.should_receive(:coerce_callable).with(input).and_return(coerced)
    end

    it { should eql(coerced) }
  end
end
