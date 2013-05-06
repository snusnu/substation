require 'spec_helper'

describe Observer::Chain, '#call' do
  subject { object.call(response) }

  let(:object) { Observer::Chain.new(observers) }

  let(:response)   { mock('Response') }
  let(:observer_a) { mock('Observer A') }
  let(:observer_b) { mock('Observer B') }

  let(:observers) { [observer_a, observer_b] }

  it_should_behave_like 'a command method'

  before do
    observer_a.stub(:call)
    observer_b.stub(:call)
  end

  it 'should call observers' do
    observer_a.should_receive(:call).with(response)
    observer_b.should_receive(:call).with(response)
    subject
  end
end
