# encoding: utf-8

describe Chain::DSL::Config, '.build' do
  subject { described_class.build(registry) }

  let(:registry)   { double('registry') }
  let(:dsl_module) { double('dsl_module') }
  let(:config)     { double('config') }

  before do
    expect(Chain::DSL::ModuleBuilder).to receive(:call).with(registry).and_return(dsl_module)
    expect(described_class).to receive(:new).with(registry, dsl_module).and_return(config)
  end

  it { should eql(config) }
end
