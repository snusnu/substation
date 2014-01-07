# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '#include?' do

  subject { object.include?(name) }

  let(:object)  { described_class.new(actions, env) }
  let(:actions) { Hash[action => double('action')] }
  let(:action)  { double('action') }
  let(:env)     { double('env') }

  context 'when the action is registered' do
    let(:name) { action }

    it 'returns true' do
      expect(subject).to be(true)
    end
  end

  context 'when the action is not registered' do
    let(:name) { :unknown }

    it 'returns false' do
      expect(subject).to be(false)
    end
  end
end
