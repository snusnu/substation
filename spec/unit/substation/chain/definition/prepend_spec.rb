# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#prepend' do
  subject { object.prepend(other) }

  let(:object)      { described_class.new([processor_1]) }
  let(:processor_1) { double('processor_1', :name => name_1) }
  let(:name_1)      { double('name_1') }
  let(:other)       { described_class.new([processor_2]) }
  let(:processor_2) { double('processor_2', :name => name_2) }
  let(:name_2)      { double('name_2') }

  it { should eql(described_class.new([processor_2, processor_1])) }
end
