# encoding: utf-8

require 'spec_helper'

describe Chain, '#call' do

  subject { object.call(request) }

  let(:object)     { described_class.new(processors) }
  let(:processors) { [ processor_1, processor_2, processor_3 ] }
  let(:request)    { Request.new(name, env, input) }
  let(:name)       { mock }
  let(:env)        { mock }
  let(:input)      { mock }

  let(:failure_chain) { mock }
  let(:handler)       { mock }

  let(:response) { response_class.new(request, request.input) }

  let(:processor_1_name) { mock }
  let(:processor_2_name) { mock }
  let(:processor_3_name) { mock }

  context "when all processors are successful" do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Incoming
        def call(request)
          request.success(request.input)
        end
      }.new(processor_1_name, handler, failure_chain)
    }

    let(:processor_2) {
      Class.new {
        include Substation::Processor::Pivot
        def call(request)
          request.success(request.input)
        end
      }.new(processor_2_name, handler, failure_chain)
    }

    let(:processor_3) {
      Class.new {
        include Substation::Processor::Outgoing
        def call(response)
          response
        end
      }.new(processor_3_name, handler)
    }

    let(:response_class) { Response::Success }

    before do
      processor_1.should_receive(:call).with(request).and_return(response)
      processor_2.should_receive(:call).with(request).and_return(response)
      processor_3.should_receive(:call).with(response).and_return(response)
    end

    it { should eql(response) }
  end

  context "when an incoming processor is not successful" do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Incoming
        def call(request)
          request.error(request.input)
        end
      }.new(processor_1_name, handler, failure_chain)
    }

    let(:processor_2) {
      Class.new {
        include Substation::Processor::Pivot
        def call(request)
          request.success(request.input)
        end
      }.new(processor_2_name, handler, failure_chain)
    }

    let(:processor_3) {
      Class.new {
        include Substation::Processor::Outgoing
        def call(response)
          response
        end
      }.new(processor_3_name, handler)
    }

    let(:response_class) { Response::Failure }

    before do
      processor_1.should_receive(:call).with(request).and_return(response)
      processor_2.should_not_receive(:call)
      processor_3.should_not_receive(:call)
    end

    it { should eql(response) }
  end

  context "when the pivot processor is not successful" do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Incoming
        def call(request)
          request.success(request.input)
        end
      }.new(processor_1_name, handler, failure_chain)
    }

    let(:processor_2) {
      Class.new {
        include Substation::Processor::Pivot
        def call(request)
          request.error(request.input)
        end
      }.new(processor_2_name, handler, failure_chain)
    }

    let(:processor_3) {
      Class.new {
        include Substation::Processor::Outgoing
        def call(response)
          response
        end
      }.new(processor_3_name, handler)
    }

    let(:response_class) { Response::Failure }

    before do
      successful_response = Response::Success.new(request, request.input)
      processor_1.should_receive(:call).with(request).and_return(successful_response)
      processor_2.should_receive(:call).with(request).and_return(response)
      processor_3.should_not_receive(:call)
    end

    it { should eql(response) }
  end

  context "when an outgoing processor is not successful" do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Pivot
        def call(request)
          request.success(request.input)
        end
      }.new(processor_1_name, handler, failure_chain)
    }

    let(:processor_2) {
      Class.new {
        include Substation::Processor::Outgoing
        def call(response)
          response.request.error(response.output)
        end
      }.new(processor_2_name, handler)
    }

    let(:processor_3) {
      Class.new {
        include Substation::Processor::Outgoing
        def call(response)
          response
        end
      }.new(processor_3_name, handler)
    }

    let(:response_class) { Response::Failure }

    before do
      successful_response = Response::Success.new(request, request.input)
      processor_1.should_receive(:call).with(request).and_return(successful_response)
      processor_2.should_receive(:call).with(successful_response).and_return(response)
      processor_3.should_receive(:call).with(response).and_return(response)
    end

    it { should eql(response) }
  end
end
