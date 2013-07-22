# encoding: utf-8

require 'spec_helper'

describe Processor, '#result' do

  subject { object.result(response) }

  include_context 'Request#initialize'
  include_context 'Processor#initialize'

  let(:klass)    { Class.new { include Substation::Processor } }
  let(:response) { Response::Success.new(request, input) }

  it { should be(response) }
end
