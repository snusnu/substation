# encoding: utf-8

require 'spec_helper'

describe Response, '#env' do
  subject { object.env }

  include_context 'Request#initialize'

  let(:object) { Class.new(described_class).new(request, output) }
  let(:output) { double }

  it { should be(env) }
end
# encoding: utf-8

require 'spec_helper'

describe Response::Failure, '#exception?' do
  subject { object.exception? }

  include_context 'Request#initialize'

  let(:object)  { Class.new(described_class).new(request, output) }
  let(:output)  { double }

  it { should be(false) }
end
# encoding: utf-8

require 'spec_helper'

describe Response, '#input' do
  subject { object.input }

  include_context 'Request#initialize'

  let(:object) { Class.new(described_class).new(request, output) }
  let(:output) { double }

  it { should be(input) }
end
# encoding: utf-8

require 'spec_helper'

describe Response, '#output' do
  subject { object.output }

  include_context 'Request#initialize'

  let(:object) { Class.new(described_class).new(request, output) }
  let(:output) { double }

  it { should equal(output) }
end
# encoding: utf-8

require 'spec_helper'

describe Response, '#request' do
  subject { object.request }

  include_context 'Request#initialize'

  let(:object) { Class.new(described_class).new(request, output) }
  let(:output) { double }

  it { should be(request) }
end
# encoding: utf-8

require 'spec_helper'

describe Response, '#to_request' do

  include_context 'Request#initialize'

  let(:object)   { Class.new(described_class).new(request, output) }
  let(:output)   { double('output') }
  let(:response) { Request.new(name, env, new_input) }

  context 'when no new input is given' do
    subject { object.to_request }

    let(:new_input) { output }

    it { should eql(response) }
  end

  context 'when new input is given' do
    subject { object.to_request(new_input) }

    let(:new_input) { double('new_input') }

    it { should eql(response) }
  end
end
