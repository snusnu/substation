# encoding: utf-8

require 'spec_helper'

describe DSL::Registry, '#[]=' do
  subject { object[name] = expected }

  let(:object)         { described_class.new(guard) }
  let(:guard)          { DSL::Guard.new(reserved_names) }
  let(:reserved_names) { EMPTY_ARRAY }
  let(:expected)       { double('expected') }
  let(:name)           { double('name', :to_sym => coerced_name) }
  let(:coerced_name)   { double('coerced_name') }

  context 'when name is not yet registered' do
    it { should be(expected) }
  end

  context 'when name is already registered' do
    let(:msg) { DSL::Guard::ALREADY_REGISTERED_MSG % coerced_name.inspect }

    before { object[name] = expected }

    specify { expect { subject }.to raise_error(AlreadyRegisteredError, msg) }
  end

  context 'when name is reserved' do
    let(:msg)            { DSL::Guard::RESERVED_NAME_MSG % coerced_name.inspect }
    let(:reserved_names) { [coerced_name] }

    specify { expect { subject }.to raise_error(ReservedNameError, msg) }
  end
end
