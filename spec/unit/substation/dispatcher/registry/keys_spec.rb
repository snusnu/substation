# encoding: utf-8

require 'spec_helper'

describe Dispatcher::Registry, '#keys' do
  subject { object.keys }

  let(:object)         { described_class.new(dispatch_table) }
  let(:dispatch_table) { { key => value } }
  let(:key)            { double('key') }
  let(:value)          { double('value') }

  it { should eql([key]) }
end
