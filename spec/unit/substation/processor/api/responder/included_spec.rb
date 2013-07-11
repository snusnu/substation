# encoding: utf-8

require 'spec_helper'

describe Processor::API::Responder, '#included' do
  subject { klass.new }

  let(:base)    { Processor::Evaluator::Result }
  let(:success) { base::Success.new(output) }
  let(:error)   { base::Failure.new(output) }
  let(:output)  { mock }

  context 'when private #respond_with is not implemented' do
    let(:klass)  do
      Class.new do
        include Processor::API::Responder.new(Processor::Evaluator::Result)
      end
    end

    [ :success, :error ].each do |method_name|
      it "raises NotImplementedError when calling ##{method_name}" do
        msg = "#{subject.class}#respond_with must be implemented"
        expect {
          subject.public_send(method_name, output)
        }.to raise_error(NotImplementedError, msg)
      end
    end
  end

  context 'when private #respond_with is implemented' do
    let(:klass)  do
      Class.new do
        include Processor::API::Responder.new(Processor::Evaluator::Result)
        private
        def respond_with(klass, output)
          klass.new(output)
        end
      end
    end

    [ :success, :error ].each do |method_name|
      it "defines public ##{method_name} on its host" do
        expect(subject.public_send(method_name, output)).to eql(send(method_name))
      end
    end
  end
end
