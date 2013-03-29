# encoding: utf-8

require 'spec_helper'

describe Action, '#call' do

  subject { object.call }

  let(:object) do
    Class.new(described_class) {
      def perform
        :response
      end
    }.new(request)
  end

  let(:request) { mock(:actor => actor, :data => data) }
  let(:actor)   { mock }
  let(:data)    { mock }

  it { should equal(:response) }
end
