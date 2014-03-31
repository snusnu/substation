# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#executor' do
  subject { processor_config.executor }

  include_context 'Processor::Config#initialize'

  it { should be(executor) }
end
# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#failure_chain' do
  subject { processor_config.failure_chain }

  include_context 'Processor::Config#initialize'

  it { should be(failure_chain) }
end
# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#observers' do
  subject { processor_config.observers }

  include_context 'Processor::Config#initialize'

  it { should be(observers) }
end
# encoding: utf-8

require 'spec_helper'

describe Processor::Config, '#with_failure_chain' do
  subject { processor_config.with_failure_chain(failure_chain) }

  include_context 'Processor::Config#initialize'

  it { should eql(processor_config) }
end
