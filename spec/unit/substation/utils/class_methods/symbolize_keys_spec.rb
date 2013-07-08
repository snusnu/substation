# encoding: utf-8

require 'spec_helper'

describe Utils, '.symbolize_keys' do

  subject { described_class.symbolize_keys(hash) }

  context 'with no nested hash' do
    let(:hash) { { 'foo' => 'bar' } }

    it { should == { :foo => 'bar' } }
  end

  context 'with a nested hash' do
    let(:hash) { { 'foo' => { 'bar' => 'baz' } } }

    it { should == { :foo => { :bar => 'baz' } } }
  end
end
