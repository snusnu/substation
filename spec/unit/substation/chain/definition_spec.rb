# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#each' do
  subject { object.each(&block) }

  let(:object)     { described_class.new(chain_name, processors) }
  let(:chain_name) { double('chain_name') }
  let(:processors) { [ processor ] }
  let(:processor)  { double('processor', :name => name) }
  let(:name)       { double('name') }
  let(:block)      { ->(_) { } }

  it_should_behave_like 'an #each method'

  it 'yields all processors' do
    expect { |block| object.each(&block) }.to yield_successive_args(processor)
  end
end

describe Chain::Definition do
  subject { described_class.new }

  it { should be_kind_of(Enumerable) }
end
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
# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#replace_failure_chain' do
  subject { object.replace_failure_chain(name, failure_chain) }

  let(:object)             { described_class.new(chain_name, processors) }
  let(:chain_name)         { double('chain_name') }
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
