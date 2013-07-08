# encoding: utf-8

require 'spec_helper'

describe Processor, '#success?' do
  subject { object.success?(response) }

  let(:object)  { klass.new(name, handler) }
  let(:klass)   { Class.new { include Processor } }
  let(:name)    { mock }
  let(:handler) { mock }

  context 'with a successful response' do
    let(:response) { mock(:success? => true) }

    it { should be(true) }
  end

  context 'with a failure response' do
    let(:response) { mock(:success? => false) }

    it { should be(false) }
  end
end
