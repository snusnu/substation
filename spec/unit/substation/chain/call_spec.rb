# encoding: utf-8

require 'spec_helper'

describe Chain, '#call' do

  subject { object.call(request) }

  let(:object)   { described_class.new(handlers) }
  let(:handlers) { [ handler_1, handler_2 ] }
  let(:request)  { Request.new(env, input) }
  let(:env)      { mock }
  let(:input)    { mock }

  let(:handler_2) {
    Class.new {
      include Substation::Chain::Outgoing
      def call(request)
        request.success(request.input)
      end
    }.new
  }

  context "when all handlers are successful" do
    let(:handler_1) {
      Class.new {
        include Substation::Chain::Incoming
        def call(request)
          request.success(request.input)
        end
      }.new
    }

    let(:response) { Response::Success.new(request, request.input) }

    it { should eql(response) }
  end

  context "when an intermediate handler is not successful" do
    let(:handler_1) {
      Class.new {
        include Substation::Chain::Incoming
        def call(request)
          request.error(request.input)
        end
      }.new
    }

    let(:response) { Response::Failure.new(request, request.input) }

    before do
      handler_2.should_not_receive(:call)
    end

    it { should eql(response) }
  end
end
