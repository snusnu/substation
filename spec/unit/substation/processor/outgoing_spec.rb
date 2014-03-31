# encoding: utf-8

require 'spec_helper'

describe Processor::Outgoing, '#call' do
  subject { object.call(request) }

  include_context 'Request#initialize'
  include_context 'Processor#initialize'

  let(:klass) {
    Class.new {
      include Substation::Processor::Outgoing
      def call(request)
        response = request.success(request.input)
        respond_with(response, :altered)
      end
    }
  }

  let(:response) { Response::Success.new(request, :altered) }

  it { should eql(response) }
end
# encoding: utf-8

require 'spec_helper'

describe Processor::Outgoing, '#name' do
  subject { object.name }

  include_context 'Processor#initialize'

  let(:klass) { Class.new { include Substation::Processor::Outgoing } }

  it { should be(processor_name) }
end
# encoding: utf-8

require 'spec_helper'

describe Processor::Outgoing, '#success?' do
  subject { object.success?(response) }

  include_context 'Processor#initialize'

  let(:klass)    { Class.new { include Substation::Processor::Outgoing } }
  let(:response) { double }

  it { should be(true) }
end
