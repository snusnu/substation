# encoding: utf-8

require 'spec_helper'

describe Processor::Outgoing, '#call' do

  subject { object.call(request) }

  include_context 'Processor#initialize'

  let(:klass) {
    Class.new {
      include Substation::Processor::Outgoing
      def call(request)
        response = request.success(request.input)
        respond_with(response, :altered)
      end
    }
  }

  let(:response) { Response::Success.new(request, :altered) }
  let(:request)  { Request.new(name, env, input) }
  let(:name)     { double }
  let(:env)      { double }
  let(:input)    { double }

  it { should eql(response) }
end
