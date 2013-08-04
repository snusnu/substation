# encoding: utf-8

shared_context 'Processor::Executor#initialize' do
  let(:executor)        { Processor::Executor.new(decomposer, composer) }
  let(:decomposer)      { double('decomposer') }
  let(:composer)        { double('composer') }
  let(:decomposed)      { double('decomposed') }
  let(:composed)        { double('composed') }
  let(:handler_result)  { double('handler_result') }
  let(:handler_output)  { double('handler_output') }
  let(:handler_success) { true }

  before do
    allow(handler_result).to receive(:success?).with(no_args).and_return(handler_success)
    allow(handler_result).to receive(:output).with(no_args).and_return(handler_output)
  end
end

shared_context 'Processor::Config#initialize' do
  include_context 'Processor::Executor#initialize'

  let(:processor_config) { Processor::Config.new(executor, failure_chain, observers) }
  let(:failure_chain)    { double('failure_chain') }
  let(:observers)        { double('observers') }
  let(:observer)         { double('observer') }
end

shared_context 'Processor#initialize' do
  include_context 'Processor::Config#initialize'

  let(:object)           { klass.new(processor_name, handler, processor_config) }
  let(:processor_name)   { double('name') }
  let(:handler)          { double('handler') }
  let(:failure_response) { double('failure_response') }
end

shared_context 'Processor::Call' do

  include_context 'Request#initialize'
  include_context 'Processor#initialize'

  let(:response)      { Response::Success.new(request, original_data) }
  let(:original_data) { double('original_data') }

  let(:expected)      { Response::Success.new(request, expected_data) }
  let(:expected_data) { composed }
end

shared_context 'Processor::Builder#initialize' do
  include_context 'Processor::Executor#initialize'

  let(:processor_builder) {
    Processor::Builder.new(processor_name, processor_klass, executor)
  }

  let(:processor_name)  { :test }
  let(:processor_klass) { Spec::Processor }
end
