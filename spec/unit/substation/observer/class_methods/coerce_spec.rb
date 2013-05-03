require 'spec_helper'

describe Observer, '.coerce' do

  subject { object.coerce(input) }

  let(:object) { described_class }

  context 'with nil input' do
    let(:input) { nil }

    it { should be(described_class::NOOP) }
  end

  context 'with string input' do
    let(:input) { 'Spec::Observer' }

    it { should be(Spec::Observer) }
  end

  context 'with array input' do
    let(:input) { ['Spec::Observer', nil] }

    let(:observers) { [Spec::Observer, described_class::NOOP] }

    it { should eql(described_class::Chain.new(observers)) }
  end

  context 'with uncoercible input' do
    let(:input) { :foo }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError, 'Uncoercible input: :foo')
    end
  end
end
