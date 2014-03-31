# encoding: utf-8

require 'spec_helper'

describe Processor, '#call' do

  context 'when the processor is no evaluator' do
    it_behaves_like 'Processor::Call::Incoming#call' do
      before do
        expect(handler).to receive(:call).with(decomposed).and_return(handler_result)
        expect(observers).to receive(:each).with(no_args).and_yield(observer)
        expect(observer).to receive(:call).with(handler_result)
      end

      let(:klass) {
        Class.new {
          include Processor::Incoming

          def call(request)
            request.success(execute(request))
          end
        }
      }
    end
  end

  # needed for rspec-dm2 to cover all processor ivars
  context 'when the processor is an evaluator' do
    it_behaves_like 'Processor::Evaluator#call' do
      let(:klass) { Processor::Evaluator::Request }
    end
  end
end
# encoding: utf-8

require 'spec_helper'

describe Processor, '#result' do

  subject { object.result(response) }

  include_context 'Request#initialize'
  include_context 'Processor#initialize'

  let(:klass)    { Class.new { include Substation::Processor } }
  let(:response) { Response::Success.new(request, input) }

  it { should be(response) }
end
# encoding: utf-8

require 'spec_helper'

describe Processor, '#success?' do
  subject { object.success?(response) }

  include_context 'Processor#initialize'

  let(:klass) { Class.new { include Substation::Processor } }

  context 'with a successful response' do
    let(:response) { double(:success? => true) }

    it { should be(true) }
  end

  context 'with a failure response' do
    let(:response) { double(:success? => false) }

    it { should be(false) }
  end
end
