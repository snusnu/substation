# encoding: utf-8

require 'spec_helper'

describe Processor::Outgoing, '#call' do

  subject { object.call(request) }

  let(:object) {
    Class.new {
      include Substation::Processor::Outgoing
      def call(request)
        response = request.success(request.input)
        respond_with(response, :altered)
      end
    }.new(processor_name, handler)
  }

  let(:processor_name) { mock }
  let(:response)       { Response::Success.new(request, :altered) }
  let(:request)        { Request.new(action_name, env, input) }
  let(:action_name)    { mock }
  let(:env)            { mock }
  let(:input)          { mock }
  let(:handler)        { mock }

  it { should eql(response) }
end
