# encoding: utf-8

require 'spec_helper'

describe Chain::FailureData, 'equalizer behavior' do
  subject { object == other }

  let(:object)    { described_class.new(data, exception) }
  let(:data)      { mock }
  let(:exception) { RuntimeError.new }

  let(:other)     { described_class.new(other_data, other_exception) }

  context 'with equal data associated' do

    let(:other_data) { data }

    context 'and equal exception classes' do
      let(:other_exception) { RuntimeError.new }

      it { should be(true) }
    end

    context 'and different exception classes' do
      let(:other_exception) { StandardError.new }

      it { should be(false) }
    end
  end

  context 'with different data associated' do
    let(:other_data) { mock }

    context 'and equal exception classes' do
      let(:other_exception) { RuntimeError.new }

      it { should be(false) }
    end

    context 'and different exception classes' do
      let(:other_exception) { StandardError.new }

      it { should be(false) }
    end
  end
end
