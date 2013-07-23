# encoding: utf-8

require 'spec_helper'

describe Processor, '#success?' do
  subject { object.success?(response) }

  include_context 'Processor#initialize'

  let(:klass) { Class.new { include Substation::Processor } }

  context 'with a successful response' do
    let(:response) { double(:success? => true) }

    it { should be(true) }
  end

  context 'with a failure response' do
    let(:response) { double(:success? => false) }

    it { should be(false) }
  end
end
