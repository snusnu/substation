# encoding: utf-8

require 'spec_helper'

describe Dispatcher::Registry, '#[]=' do
  subject { object[name] = callable }

  let(:object)       { described_class.new }
  let(:callable)     { double('callable') }
  let(:name)         { double('name', :to_sym => coerced_name) }
  let(:coerced_name) { double('coerced_name') }

  context 'when name is not yet registered' do
    it { should be(callable) }
  end

  context 'when name is already registered' do
    let(:msg) { "#{coerced_name.inspect} is already registered" }

    before { object[name] = callable }

    specify { expect { subject }.to raise_error(AlreadyRegisteredError, msg) }
  end
end
