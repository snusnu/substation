# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#replace_failure_chain' do
  subject { object.replace_failure_chain(name, failure_chain) }

  let(:object)             { described_class.new(processors) }
  let(:processor)          { double('processor', :name => name) }
  let(:name)               { double('name') }
  let(:other_processor)    { double('other_processor', :name => other_name) }
  let(:other_name)         { double('other_name') }
  let(:failure_chain)      { double('failure_chain') }
  let(:replaced_processor) { double('replaced_processor') }

  context 'when a processor is registered under the given name' do
    before do
      expect(processor).to receive(:with_failure_chain).with(failure_chain).and_return(replaced_processor)
    end

    context 'when one processor is registered under the given name' do
      let(:processors) { [other_processor, processor] }

      it 'replaces the processor with a new one' do
        expect(subject.each).to include(replaced_processor)
      end

      it_behaves_like 'a command method'
    end

    context 'when more than one processor is registered under the given name' do
      let(:processors)          { [other_processor, processor, same_name_processor] }
      let(:same_name_processor) { double('same_name_processor', :name => name) }

      it 'replaces the first processor with a new one' do
        expect(subject.each).to include(replaced_processor)
        expect(subject.each).to include(same_name_processor)
      end

      it_behaves_like 'a command method'
    end
  end

  context 'when no processor is registered under the given name' do
    let(:processors) { [] }

    it 'raises an UnknownProcessorError' do
      expect { subject }.to raise_error(UnknownProcessor, "No processor named #{name.inspect} is registered")
    end
  end
end
