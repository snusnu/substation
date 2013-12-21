# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#chain' do
  subject { object.chain(other_processors) }

  let(:object)     { described_class.new(config, definition) }
  let(:config)     { Chain::DSL::Config.new(registry, dsl_module) }
  let(:registry)   { double('registry') }
  let(:dsl_module) { Module.new }
  let(:name)       { double('name') }

  let(:definition) { Chain::Definition.new(name, processors) }
  let(:processors) { [processor] }
  let(:processor)  { double('processor', :name => :processor) }

  let(:other_definition) { Chain::Definition.new(name, other_processors) }
  let(:other_processors) { [other_processor] }
  let(:other_processor)  { double('other_processor', :name => :other_processor) }

  let(:expected)            { described_class.new(config, expected_definition) }
  let(:expected_definition) { other_definition.prepend(definition) }

  it { should eql(expected) }
end
