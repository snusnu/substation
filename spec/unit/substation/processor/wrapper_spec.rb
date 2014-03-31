# encoding: utf-8

require 'spec_helper'

describe Processor::Wrapper, '#call' do
  it_behaves_like 'Processor::Call::Incoming#call' do
    before do
      expect(handler).to receive(:new).with(decomposed).and_return(handler_result)
    end

    let(:klass) {
      Class.new {
        include Processor::Incoming
        include Processor::Wrapper

        def call(request)
          request.success(execute(request))
        end
      }
    }
  end
end

