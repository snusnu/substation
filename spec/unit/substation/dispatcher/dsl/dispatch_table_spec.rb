# encoding: utf-8

require 'spec_helper'

describe Dispatcher::DSL, '#dispatch_table' do
  subject { object.dispatch_table }

  let(:object) { described_class.new(&block) }
  let(:block)  { ->(_) { dispatch :test, Chain::EMPTY } }

  it { should eql({ :test => Chain::EMPTY }) }
end
