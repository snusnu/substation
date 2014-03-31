# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::Config, '#dsl_module' do
  subject { object.dsl_module }

  let(:object)     { described_class.new(registry, dsl_module) }
  let(:registry)   { double('registry') }
  let(:dsl_module) { double('dsl_module') }

  it { should be(dsl_module) }
end
