# encoding: utf-8

require 'spec_helper'

describe Processor, '#success?' do
  subject { object.success?(response) }

  let(:object)  { klass.new }
  let(:klass)   { Class.new { include Processor } }

  context 'with a successful response' do
    let(:response) { mock(:success? => true) }

    it { should be(true) }
  end

  context 'with a failure response' do
    let(:response) { mock(:success? => false) }

    it { should be(false) }
  end
end
