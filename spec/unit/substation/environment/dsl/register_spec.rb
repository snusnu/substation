require 'spec_helper'

describe Environment::DSL, '#register' do

  let(:object)    { described_class.new }
  let(:name)      { :test }
  let(:processor) { Spec::Processor }

  shared_examples_for 'Environment::DSL#register' do
    it "registers the given processor" do
      expect(subject.registry).to eql(expected)
    end
  end

  context "when a block is given" do
    subject { object.register(name, processor, &block) }

    let(:block)    { lambda { |_| register :test, Spec::Processor } }
    let(:expected) { { :test => { :class => Spec::Processor, :block => block } } }

    it_behaves_like 'a command method'
    it_behaves_like 'Environment::DSL#register'
  end

  context "when no block is given" do
    subject { object.register(name, processor) }

    let(:expected) { { :test => { :class => Spec::Processor, :block => nil } } }

    it_behaves_like 'a command method'
    it_behaves_like 'Environment::DSL#register'
  end
end
