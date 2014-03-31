# encoding: utf-8

require 'spec_helper'

describe Response::Success, '#exception?' do
  subject { object.exception? }

  include_context 'Request#initialize'

  let(:object)  { described_class.new(request, output) }
  let(:output)  { double }

  it { should be(false) }
end
# encoding: utf-8

require 'spec_helper'

describe Response::Success, '#success?' do
  subject { object.success? }

  include_context 'Request#initialize'

  let(:object) { described_class.new(request, output) }
  let(:output) { double }

  it { should be(true) }
end
