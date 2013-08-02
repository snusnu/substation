# encoding: utf-8

require 'spec_helper'

describe Response::Failure, '#exception?' do
  subject { object.exception? }

  include_context 'Request#initialize'

  let(:object)  { described_class.new(request, output) }
  let(:output)  { double }

  it { should be(false) }
end
