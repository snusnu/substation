# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::ModuleBuilder, '.call' do
  subject { described_class.call(registry) }

  let(:registry)          { { :test => processor_builder } }
  let(:processor_builder) { double('processor_builder') }

  let(:instance)   { double('module_builder', :dsl_module => dsl_module) }
  let(:dsl_module) { double('dsl_module') }

  before do
    expect(described_class).to receive(:new).with(registry).and_return(instance)
    expect(instance).to receive(:dsl_module).and_return(dsl_module)
  end

  it { should be(dsl_module) }
end
