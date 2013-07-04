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
    }.new(failure_chain, handler)
  }

  let(:response) { Response::Success.new(request, :altered) }
  let(:request)  { Request.new(name, env, input) }
  let(:name)     { mock }
  let(:env)      { mock }
  let(:input)    { mock }

  let(:failure_chain) { mock }
  let(:handler)       { mock }

  it { should eql(response) }
end
