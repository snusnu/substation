# encoding: utf-8

require 'spec_helper'

describe Action, '.call' do

  subject { object.call(request) }

  let(:object) {
    Class.new(described_class) {
      def perform
        :response
      end
    }
  }

  let(:request) { mock(:actor => actor, :data => data) }
  let(:actor)   { mock }
  let(:data)    { mock }

  it { should equal(:response) }
end
