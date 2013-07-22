# encoding: utf-8

require 'spec_helper'

describe Chain::FailureData, '#hash' do
  subject { object.hash }

  let(:object)    { described_class.new(data, exception) }
  let(:data)      { double }
  let(:exception) { double }

  it { should eql(described_class.hash ^ data.hash ^ exception.class.hash) }
end
