# encoding: utf-8

require 'spec_helper'

describe Request, '#env' do
  subject { request.env }

  include_context 'Request#initialize'

  it { should be(env) }
end
# encoding: utf-8

require 'spec_helper'

describe Request, '#error' do
  subject { request.error(output) }

  include_context 'Request#initialize'

  let(:output) { double }

  it { should eql(Response::Failure.new(request, output)) }
end
# encoding: utf-8

require 'spec_helper'

describe Request, '#input' do
  subject { request.input }

  include_context 'Request#initialize'

  it { should be(input) }
end
# encoding: utf-8

require 'spec_helper'

describe Request, '#name' do
  subject { request.name }

  include_context 'Request#initialize'

  it { should be(name) }
end
# encoding: utf-8

require 'spec_helper'

describe Request, '#success' do
  subject { request.success(output) }

  include_context 'Request#initialize'

  let(:output) { double }

  it { should eql(Response::Success.new(request, output)) }
end
# encoding: utf-8

require 'spec_helper'

describe Request, '#to_request' do
  include_context 'Request#initialize'

  let(:object) { request }

  context 'when no input is given' do
    subject { object.to_request }

    it { should be(object) }
  end

  context 'when input is given' do
    subject { object.to_request(new_input) }

    let(:expected)  { described_class.new(name, env, new_input) }
    let(:new_input) { double('new_input') }

    it { should eql(expected) }
  end
end
