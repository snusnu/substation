# encoding: utf-8

require 'spec_helper'

describe Response::Failure do

  let(:object)  { described_class.new(request, output) }
  let(:output)  { double }

  describe '#exception?' do
    subject { object.exception? }

    include_context 'Request#initialize'

    it { should be(false) }
  end

  describe '#success?' do
    subject { object.success? }

    include_context 'Request#initialize'

    it { should be(false) }
  end
end
