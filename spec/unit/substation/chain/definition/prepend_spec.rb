# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#prepend' do
  subject { object.prepend(other) }

  let(:object)      { described_class.new(name, [processor_1]) }
  let(:name)        { double('chain_name') }
  let(:processor_1) { double('processor_1', :name => name_1) }
  let(:name_1)      { double('name_1') }
  let(:other_name)  { double('other_chain_name') }
  let(:other)       { described_class.new(other_name, [processor_2]) }
  let(:name_2)      { double('name_2') }

  context 'and the processors are disjoint' do
    let(:processor_2) { double('processor_2', :name => name_2) }

    it { should eql(described_class.new(name, [processor_2, processor_1])) }
  end

  context 'and the processors contain duplicates' do
    let(:processor_2) { processor_1 }
    let(:msg)         { Chain::Definition::DUPLICATE_PROCESSOR_MSG % [processor_2].inspect }

    it 'raises DuplicateProcessorError' do
      expect { subject }.to raise_error(DuplicateProcessorError, msg)
    end
  end
end
