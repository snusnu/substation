# encoding: utf-8

require 'spec_helper'

describe Utils, '.const_get' do

  subject { described_class.const_get(name) }

  context "with a toplevel constant" do
    context "given as String" do
      let(:name) { 'Substation' }

      it { should == Substation }
    end

    context "given as Symbol" do
      let(:name) { :Substation }

      it { should == Substation }
    end
  end

  context "with a FQN toplevel constant" do
    let(:name) { '::Substation' }

    it { should == Substation }
  end

  context "with a nested constant" do
    let(:name) { 'Substation::Request' }

    it { should == Substation::Request }
  end

  context "with a non-existant nested constant" do
    let(:name) { 'Substation::Foo' }

    before do
      Substation.should_receive(:const_missing).with('Foo')
    end

    it { should be(nil) }
  end
end
