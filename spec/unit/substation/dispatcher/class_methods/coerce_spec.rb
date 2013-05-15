# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '.coerce' do

  subject { described_class.coerce(config, env) }

  let(:config) {{
    'test' => { 'action' => 'Spec::Action::Success' }
  }}

  let(:env) { mock }

  let(:coerced) {{
    :test => described_class::Action.coerce(:action => 'Spec::Action::Success')
  }}

  it { should eql(described_class.new(coerced, env)) }
end
