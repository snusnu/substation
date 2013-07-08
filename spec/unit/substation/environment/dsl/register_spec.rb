require 'spec_helper'

describe Environment::DSL, '#register' do
  subject { object.register(name, processor) }

  let(:object)    { described_class.new }
  let(:name)      { :test }
  let(:processor) { Spec::Processor }

  let(:expected) { { :test => Spec::Processor } }

  it_behaves_like 'a command method'

  it "registers the given processor" do
    expect(subject.registry).to eql(expected)
  end
end
