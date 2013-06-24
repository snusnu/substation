# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#use' do
  subject { object.use(processor) }

  let(:object)    { described_class.new(env, chain) }
  let(:env)       { Spec::FAKE_ENV }
  let(:chain)     { Chain::EMPTY }
  let(:processor) { Spec::FAKE_PROCESSOR }

  its(:processors) { should include(processor) }
end
