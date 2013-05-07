require 'spec_helper'

describe Observer::NULL, '#call' do
  subject { object.call(input) }

  let(:object) { described_class }
  let(:input)  { mock   }

  it_should_behave_like 'a command method'

  it { should be_kind_of(Observer) }
end
