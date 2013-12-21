# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#failure_chain' do
  subject { object.failure_chain(name, failure_chain) }

  let(:object)        { described_class.new(config, definition) }
  let(:config)        { Chain::DSL::Config.new(registry, dsl_module) }
  let(:registry)      { double('registry') }
  let(:dsl_module)    { Module.new }
  let(:definition)    { double('definition', :name => double('chain_name')) }
  let(:name)          { double('name') }
  let(:failure_chain) { double('failure_chain') }

  before do
    expect(definition).to receive(:replace_failure_chain).with(name, failure_chain)
  end

  it_behaves_like 'a command method'
end
