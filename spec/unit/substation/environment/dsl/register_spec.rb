require 'spec_helper'

describe Substation::Environment::DSL, '#register' do
  subject { object.register(name, processor) }

  let(:object)    { described_class.new }
  let(:name)      { :test }
  let(:processor) { Spec::Processor }

  let(:expected) { { :test => Spec::Processor } }
  let(:block)    { lambda { |_| register :test, Spec::Processor } }

  its(:registry) { should eql(expected) }
end
