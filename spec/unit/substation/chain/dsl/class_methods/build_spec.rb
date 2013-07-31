# encoding: utf-8

describe Chain::DSL, '.build' do

  let(:registry)   { double('registry') }
  let(:dsl)        { double('dsl') }
  let(:config)     { double('config') }
  let(:definition) { double('definition') }

  before do
    expect(Chain::DSL::Config).to receive(:build).with(registry).and_return(config)
    expect(described_class).to receive(:new).with(config, definition).and_return(dsl)
  end

  context 'when a definition is given' do
    subject { described_class.build(registry, definition) }

    it { should be(dsl) }
  end

  context 'when no definition is given' do
    subject { described_class.build(registry) }

    let(:definition) { Chain::Definition::EMPTY }

    it { should be(dsl) }
  end
end
