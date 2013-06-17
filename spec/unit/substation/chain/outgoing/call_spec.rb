# encoding: utf-8

require 'spec_helper'

describe Chain::Outgoing, '#call' do

  subject { object.call(request) }

  let(:object) {
    Class.new {
      include Substation::Chain::Outgoing
      def call(request)
        response = request.success(request.input)
        respond_with(response, :altered)
      end
    }.new
  }

  let(:response) { Response::Success.new(request, :altered) }
  let(:request)  { Request.new(env, input) }
  let(:env)      { mock }
  let(:input)    { mock }

  it { should eql(response) }
end
