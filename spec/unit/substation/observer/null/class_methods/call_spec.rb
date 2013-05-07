require 'spec_helper'

describe Observer::Null, '.call' do
  subject { object.call(input) }

  let(:object) { described_class }
  let(:input)  { mock('Input')   }

  it_should_behave_like 'a command method'
end
