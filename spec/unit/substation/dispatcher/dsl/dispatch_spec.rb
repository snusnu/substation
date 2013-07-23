# encoding: utf-8

require 'spec_helper'

describe Dispatcher::DSL, '#dispatch' do
  subject { object.dispatch(name, callable) }

  let(:object)       { described_class.new }
  let(:callable)     { double }
  let(:name)         { double(:to_sym => coerced_name) }
  let(:coerced_name) { double }

  context 'when name is not yet registered' do
    it_behaves_like 'a command method'

    its(:dispatch_table) { should eql(coerced_name => callable) }
  end

  context 'when name is already registered' do
    let(:msg) { "#{coerced_name.inspect} is already registered" }

    before { object.dispatch(name, callable) }

    specify { expect { subject }.to raise_error(AlreadyRegisteredError, msg) }
  end
end
