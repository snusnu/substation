# encoding: utf-8

shared_context 'Chain::DSL#initialize' do
  let(:chain_dsl)      { Chain::DSL.build(registry, definition) }
  let(:registry)       { Environment::DSL.registry(&env_block) }
  let(:env_block)      { ->(_) { register(:test, Spec::Processor) } }
  let(:processor_name) { :test }

  let(:definition)     { Chain::Definition.new(processors) }
  let(:processors)     { [processor] }
  let(:processor)      { double('processor') }
end
