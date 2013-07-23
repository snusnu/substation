# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '.build' do

  let(:env) { double }

  context 'when no block is given' do
    subject { described_class.build(env) }

    it { should eql(Dispatcher.new({}, env)) }
  end

  context 'when a block is given' do
    subject { described_class.build(env, &block) }

    let(:block) { ->(_) { dispatch :test, Chain::EMPTY } }

    it { should eql(Dispatcher.new({ :test => Chain::EMPTY }, env)) }
  end
end
