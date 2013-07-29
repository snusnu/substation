# encoding: utf-8

require 'spec_helper'

describe Chain::Definition, '#<<' do
  subject { object << processor }

  let(:object)    { described_class.new }
  let(:processor) { double('processor', :name => name) }
  let(:name)      { double('name') }

  it 'registers the processor' do
    expect(subject.each).to include(processor)
  end

  it_behaves_like 'a command method'
end
