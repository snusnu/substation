# encoding: utf-8

require 'spec_helper'

describe Chain, '#call' do

  subject { object.call(request) }

  let(:object)          { described_class.new(processors, exception_chain) }
  let(:exception_chain) { mock(:call => response) }
  let(:processors)      { [ processor_1, processor_2, processor_3 ] }
  let(:request)         { Request.new(name, env, input) }
  let(:name)            { mock }
  let(:env)             { mock }
  let(:input)           { mock }

  let(:failure_chain) { mock }
  let(:handler)       { mock }

  let(:processor_1_name) { mock }
  let(:processor_2_name) { mock }
  let(:processor_3_name) { mock }

  context 'when all processors are successful' do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Incoming
        def call(request)
          request.success(:success_1)
        end
      }.new(processor_1_name, handler, failure_chain)
    }

    let(:processor_2) {
      Class.new {
        include Substation::Processor::Pivot
        def call(request)
          request.success(:success_2)
        end
      }.new(processor_2_name, handler, failure_chain)
    }

    let(:processor_3) {
      Class.new {
        include Substation::Processor::Outgoing
        def call(response)
          respond_with(response, :success_3)
        end
      }.new(processor_3_name, handler)
    }

    let(:response)        { Response::Success.new(current_request, :success_3) }
    let(:current_request) { Request.new(name, env, :success_1) }

    it { should eql(response) }
  end

  context 'when an incoming processor is not successful' do

    let(:processor_2) {
      Class.new {
        include Substation::Processor::Pivot
        def call(request)
          request.success(:success_1)
        end
      }.new(processor_2_name, handler, failure_chain)
    }

    let(:processor_3) {
      Class.new {
        include Substation::Processor::Outgoing
        def call(response)
          respond_with(response, :success_3)
        end
      }.new(processor_3_name, handler)
    }

    let(:response_class) { Response::Failure }

    context 'because it returned a failure response' do
      let(:processor_1) {
        Class.new {
          include Substation::Processor::Incoming
          def call(request)
            request.error(:error_1)
          end
        }.new(processor_1_name, handler, failure_chain)
      }

      let(:response) { Response::Failure.new(request, :error_1) }

      it { should eql(response) }
    end

    context 'because it raised an uncaught exception' do
      let(:processor_1) {
        Class.new {
          include Substation::Processor::Incoming
          def call(request)
            raise RuntimeError, 'exception_1'
          end
        }.new(processor_1_name, handler, failure_chain)
      }

      let(:response) { Response::Failure.new(request, data) }
      let(:data)     { Chain::FailureData.new(request, RuntimeError.new('exception_1')) }

      it { should eql(response) }

      it 'wraps the original exception instance' do
        expect(subject.output.exception.message).to eql('exception_1')
      end

      it 'calls the failure chain' do
        exception_chain.should_receive(:call).with(response)
        subject
      end
    end
  end

  context 'when the pivot processor is not successful' do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Incoming
        def call(request)
          request.success(:success_1)
        end
      }.new(processor_1_name, handler, failure_chain)
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

    context 'because it returned a failure response' do
      let(:processor_2) {
        Class.new {
          include Substation::Processor::Pivot
          def call(request)
            request.error(:error_2)
          end
        }.new(processor_2_name, handler, failure_chain)
      }

      let(:response)        { Response::Failure.new(current_request, :error_2) }
      let(:current_request) { Request.new(name, env, :success_1) }

      it { should eql(response) }
    end

    context 'because it raised an uncaught exception' do
      let(:processor_2) {
        Class.new {
          include Substation::Processor::Pivot
          def call(request)
            raise RuntimeError, 'exception_2'
          end
        }.new(processor_2_name, handler, failure_chain)
      }

      let(:response)        { Response::Failure.new(request, data) }
      let(:data)            { Chain::FailureData.new(current_request, RuntimeError.new('exception_2')) }
      let(:current_request) { Request.new(name, env, :success_1) }

      it { should eql(response) }

      it 'wraps the original exception instance' do
        expect(subject.output.exception.message).to eql('exception_2')
      end

      it 'calls the failure chain' do
        exception_chain.should_receive(:call).with(response)
        subject
      end
    end
  end

  context 'when an outgoing processor is not successful' do
    let(:processor_1) {
      Class.new {
        include Substation::Processor::Incoming
        def call(request)
          request.success(:success_1)
        end
      }.new(processor_1_name, handler, failure_chain)
    }

    let(:processor_2) {
      Class.new {
        include Substation::Processor::Pivot
        def call(response)
          response.success(:success_2)
        end
      }.new(processor_2_name, handler, failure_chain)
    }

    let(:response_class) { Response::Failure }

    context 'because it raised an uncaught exception' do
      let(:processor_3) {
        Class.new {
          include Substation::Processor::Outgoing
          def call(response)
            raise RuntimeError, 'exception_3'
          end
        }.new(processor_3_name, handler)
      }

      let(:response)         { Response::Failure.new(request, data) }
      let(:data)             { Chain::FailureData.new(current_response, RuntimeError.new('exception_3')) }
      let(:current_request)  { Request.new(name, env, :success_1) }
      let(:current_response) { Response::Success.new(current_request, :success_2) }

      it { should eql(response) }

      it 'wraps the original exception instance' do
        expect(subject.output.exception.message).to eql('exception_3')
      end

      it 'calls the failure chain' do
        exception_chain.should_receive(:call).with(response)
        subject
      end
    end
  end
end
