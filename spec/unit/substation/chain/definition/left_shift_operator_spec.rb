# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#<<' do
  subject { object << processor }

  let(:object)     { described_class.new(chain_name, processors) }
  let(:chain_name) { double('chain_name') }
  let(:processor)  { double('processor', :name => name) }
  let(:name)       { double('name') }

  context 'when the given processor is not currently present in object' do
    let(:processors) { [] }

    it 'registers the processor' do
      expect(subject.each).to include(processor)
    end

    it_behaves_like 'a command method'
  end

  context 'when the given processor is already present in object' do
    let(:processors) { [processor] }
    let(:msg)        { Chain::Definition::DUPLICATE_PROCESSOR_MSG % [processor].inspect }

    it 'raises DuplicateProcessorError' do
      expect { subject }.to raise_error(DuplicateProcessorError, msg)
    end
  end
end
