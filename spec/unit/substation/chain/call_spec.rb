# encoding: utf-8

require 'spec_helper'

describe Chain, '#call' do

  subject { object.call(request) }

  let(:object)     { described_class.new(processors) }
  let(:processors) { [ processor_1, processor_2 ] }
  let(:request)    { Request.new(name, env, input) }
  let(:name)       { mock }
  let(:env)        { mock }
  let(:input)      { mock }

  let(:failure_chain) { mock }
  let(:handler)       { mock }

  let(:processor_2) {
    Class.new {
      include Substation::Processor::Outgoing
      def call(request)
        request.success(request.input)
      end
    }.new(failure_chain, handler)
  }

  let(:response) { response_class.new(request, request.input) }

  context "when all processors are successful" do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Incoming
        def call(request)
          request.success(request.input)
        end
      }.new(failure_chain, handler)
    }

    let(:response_class) { Response::Success }

    before do
      processor_2.should_receive(:call).with(request).and_return(response)
    end

    it { should eql(response) }
  end

  context "when an intermediate processor is not successful" do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Incoming
        def call(request)
          request.error(request.input)
        end
      }.new(failure_chain, handler)
    }

    let(:response_class) { Response::Failure }

    before do
      processor_2.should_not_receive(:call)
    end

    it { should eql(response) }
  end
end
