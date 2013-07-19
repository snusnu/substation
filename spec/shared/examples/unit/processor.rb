# encoding: utf-8

shared_examples_for 'Processor::Call::Outgoing#call' do
  subject { object.call(response) }

  include_context 'Processor::Call'

  it { should eql(expected) }
end

shared_examples_for 'Processor::Call::Incoming#call' do
  subject { object.call(request) }

  include_context 'Processor::Call'

  it { should eql(expected) }
end

shared_examples_for 'Processor::Evaluator#call' do
  subject { object.call(request) }

  include_context 'Request#initialize'
  include_context 'Processor#initialize'

  context 'with a successful handler' do
    let(:handler)  { Spec::Action::Success }
    let(:response) { Response::Success.new(request, Spec.response_data) }

    it { should eql(response) }
  end

  context 'with a failing handler' do
    let(:handler)  { Spec::Action::Failure }
    let(:response) { Response::Failure.new(request, Spec.response_data) }

    before do
      expect(failure_chain).to receive(:call).with(response).and_return(failure_response)
    end

    it { should eql(failure_response) }
  end
end
