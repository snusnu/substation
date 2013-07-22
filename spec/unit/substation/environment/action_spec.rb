# encoding: utf-8

require 'spec_helper'

describe Environment, '#action' do

  let(:object)      { described_class.new(registry, chain_dsl) }
  let(:registry)    { double }
  let(:chain_dsl)   { double }
  let(:handler)     { double }

  context 'when no observers are given' do
    subject { object.action(handler) }

    it { should eql(Action.new(handler, EMPTY_ARRAY)) }
  end

  context 'when observers are given' do
    subject { object.action(handler, observers) }
    let(:observers) { [ Spec::Observer ] }

    it { should eql(Action.new(handler, observers)) }
  end
end
