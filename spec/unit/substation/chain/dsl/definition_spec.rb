# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#definition' do
  subject { object.definition }

  include_context 'Chain::DSL#initialize'

  let(:object) { chain_dsl }

  it { should eql(definition) }
end
