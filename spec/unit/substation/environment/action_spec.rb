# encoding: utf-8

require 'spec_helper'

describe Environment, '#action' do

  let(:object)      { described_class.new(chain_dsl) }
  let(:chain_dsl)   { double('chain_dsl', :registry => registry) }
  let(:registry)    { double('registry') }
  let(:handler)     { double('handler') }

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
