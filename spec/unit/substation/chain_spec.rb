# encoding: utf-8

require 'spec_helper'

describe Chain do
  describe '#call' do

    subject { object.call(request) }

    include_context 'Request#initialize'

    let(:object)          { described_class.new(processors, exception_chain) }
    let(:exception_chain) { double(:call => response) }
    let(:processors)      { [ processor_1, processor_2, processor_3 ] }

    let(:processor_1_name) { double }
    let(:processor_2_name) { double }
    let(:processor_3_name) { double }

    let(:processor_config) { Processor::Config.new(handler, failure_chain, executor) }
    let(:handler)          { double('handler') }
    let(:failure_chain)    { double(:call => failure_response) }
    let(:failure_response) { double }
    let(:executor)         { Processor::Executor::NULL }

    context 'when all processors are successful' do
      let(:processor_1) {
        Class.new {
          include Substation::Processor::Incoming
          def call(request)
            request.success(:success_1)
          end
        }.new(processor_1_name, handler, processor_config)
      }

      let(:processor_2) {
        Class.new {
          include Substation::Processor::Pivot
          def call(request)
            request.success(:success_2)
          end
        }.new(processor_2_name, handler, processor_config)
      }

      let(:processor_3) {
        Class.new {
          include Substation::Processor::Outgoing
          def call(response)
            respond_with(response, :success_3)
          end
        }.new(processor_3_name, handler, processor_config)
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
        }.new(processor_2_name, handler, processor_config)
      }

      let(:processor_3) {
        Class.new {
          include Substation::Processor::Outgoing
          def call(response)
            respond_with(response, :success_3)
          end
        }.new(processor_3_name, handler, processor_config)
      }

      let(:response_class) { Response::Failure }

      context 'because it returned a failure response' do
        let(:processor_1) {
          Class.new {
            include Substation::Processor::Incoming
            def call(request)
              request.error(:error_1)
            end
          }.new(processor_1_name, handler, processor_config)
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
          }.new(processor_1_name, handler, processor_config)
        }

        let(:response) { Response::Exception.new(request, data) }
        let(:data)     { Response::Exception::Output.new(input, RuntimeError.new('exception_1')) }

        it { should eql(response) }

        it 'wraps the original exception instance' do
          expect(subject.output.exception.message).to eql('exception_1')
        end

        it 'calls the failure chain' do
          expect(exception_chain).to receive(:call).with(response)
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
        }.new(processor_1_name, handler, processor_config)
      }

      let(:processor_3) {
        Class.new {
          include Substation::Processor::Outgoing
          def call(response)
            response
          end
        }.new(processor_3_name, handler, processor_config)
      }

      let(:response_class) { Response::Failure }

      context 'because it returned a failure response' do
        let(:processor_2) {
          Class.new {
            include Substation::Processor::Pivot
            def call(request)
              request.error(:error_2)
            end
          }.new(processor_2_name, handler, processor_config)
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
          }.new(processor_2_name, handler, processor_config)
        }

        let(:response)        { Response::Exception.new(request.to_request(:success_1), data) }
        let(:data)            { Response::Exception::Output.new(:success_1, RuntimeError.new('exception_2')) }
        let(:current_request) { Request.new(name, env, :success_1) }

        it { should eql(response) }

        it 'wraps the original exception instance' do
          expect(subject.output.exception.message).to eql('exception_2')
        end

        it 'calls the failure chain' do
          expect(exception_chain).to receive(:call).with(response)
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
        }.new(processor_1_name, handler, processor_config)
      }

      let(:processor_2) {
        Class.new {
          include Substation::Processor::Pivot
          def call(response)
            response.success(:success_2)
          end
        }.new(processor_2_name, handler, processor_config)
      }

      let(:response_class) { Response::Failure }

      context 'because it raised an uncaught exception' do
        let(:processor_3) {
          Class.new {
            include Substation::Processor::Outgoing
            def call(response)
              raise RuntimeError, 'exception_3'
            end
          }.new(processor_3_name, handler, processor_config)
        }

        let(:response)         { Response::Exception.new(request.to_request(:success_2), data) }
        let(:data)             { Response::Exception::Output.new(:success_2, RuntimeError.new('exception_3')) }
        let(:current_request)  { Request.new(name, env, :success_1) }
        let(:current_response) { Response::Success.new(current_request, :success_2) }

        it { should eql(response) }

        it 'wraps the original exception instance' do
          expect(subject.output.exception.message).to eql('exception_3')
        end

        it 'calls the failure chain' do
          expect(exception_chain).to receive(:call).with(response)
          subject
        end
      end
    end
  end

  describe '#each' do
    subject { object.each { |tuple| yields << processor } }

    let(:object)     { described_class.new(processors, described_class::EMPTY) }
    let(:processors) { [ processor ] }
    let(:processor)  { Spec::FAKE_PROCESSOR }
    let(:yields)     { [] }

    before do
      expect(object).to be_instance_of(described_class)
    end

    it_should_behave_like 'an #each method'

    it 'yields only processors' do
      subject
      yields.each { |processor| expect(processor).to be_instance_of(Spec::Processor) }
    end

    it 'yields only processors with the expected handler' do
      expect { subject }.to change { yields.dup }
        .from([])
        .to([ processor ])
    end
  end

  describe Chain do
    subject { described_class.new(processors, described_class::EMPTY) }

    let(:processors) { [ processor ] }
    let(:processor)  { Spec::FAKE_PROCESSOR }

    before do
      expect(subject).to be_instance_of(described_class)
    end

    it { should be_kind_of(Enumerable) }
  end

  describe '.exception_response' do
    subject { described_class.exception_response(state, data, exception) }

    include_context 'Request#initialize'

    let(:data)           { double('data') }
    let(:exception)      { double('exception') }
    let(:exception_data) { Response::Exception::Output.new(data, exception) }

    let(:expected)         { Response::Exception.new(expected_request, exception_data) }

    context 'when a request is passed as current state' do
      let(:state)            { request }
      let(:expected_request) { request.to_request(data) }

      it { should eql(expected) }
    end

    context 'when a response is passed as current state' do
      let(:state)            { response }
      let(:expected_request) { response.to_request(data) }
      let(:response)         { Response::Failure.new(request, output) }
      let(:output)           { double('output') }

      it { should eql(expected) }
    end
  end
end
