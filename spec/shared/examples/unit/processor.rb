# encoding: utf-8

shared_examples_for 'Processor::Call::Outgoing#call' do
  subject { object.call(response) }

  include_context 'Processor::Call'

  before do
    expect(decomposer).to receive(:call).with(response).and_return(decomposed)
    expect(handler_result).to_not receive(:success?)
    expect(handler_result).to_not receive(:output)
    expect(composer).to receive(:call).with(response, handler_result).and_return(composed)
  end

  it { should eql(expected) }
end

shared_examples_for 'Processor::Call::Incoming#call' do
  subject { object.call(request) }

  include_context 'Processor::Call'

  before do
    expect(decomposer).to receive(:call).with(request).and_return(decomposed)
    expect(handler_result).to_not receive(:success?)
    expect(handler_result).to_not receive(:output)
    expect(composer).to receive(:call).with(request, handler_result).and_return(composed)
  end

  it { should eql(expected) }
end

shared_examples_for 'Processor::Evaluator#call' do
  subject { object.call(request) }

  include_context 'Processor::Call'

  context 'with a successful handler' do
    before do
      expect(decomposer).to receive(:call).with(request).and_return(decomposed)
      expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
      expect(handler_result).to receive(:success?)
      expect(handler_result).to receive(:output)
      expect(composer).to receive(:call).with(request, handler_output).and_return(composed)
    end

    it { should eql(expected) }
  end

  context 'with a failing handler' do
    let(:handler_success) { false }
    let(:response)        { Response::Failure.new(request, composed) }

    before do
      expect(decomposer).to receive(:call).with(request).and_return(decomposed)
      expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
      expect(handler_result).to receive(:success?)
      expect(handler_result).to receive(:output)
      expect(composer).to receive(:call).with(request, handler_output).and_return(composed)
      expect(failure_chain).to receive(:call).with(response).and_return(failure_response)
    end

    it { should eql(failure_response) }
  end
end
