# encoding: utf-8

require 'spec_helper'

describe Dispatcher::Registry, '#keys' do
  subject { object.keys }

  let(:object)         { described_class.new(dispatch_table) }
  let(:dispatch_table) { double('dispatch_table', :keys => keys) }
  let(:keys)           { double('keys') }

  it { should eql(keys) }
end
