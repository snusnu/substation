# encoding: utf-8

require 'app'

describe 'a typical substation application' do
  subject { Demo::APP.call(name, input) }

  let(:request) { Substation::Request.new(name, env, input) }
  let(:name)    { :create_person }
  let(:env)     { Demo::APP_ENV }

  shared_examples_for 'an action invocation' do
    it 'notifies all observers' do
      Demo::Observers::LOG_EVENT.should_receive(:call).with(action_response)
      Demo::Observers::SEND_EMAIL.should_receive(:call).with(action_response)
      subject
    end
  end

  shared_examples_for 'no action invocation' do
    it 'does not notify any observers' do
      Demo::Observers::LOG_EVENT.should_not_receive(:call)
      Demo::Observers::SEND_EMAIL.should_not_receive(:call)
      subject
    end
  end

  context 'with valid input' do
    let(:input) { { 'name' => 'John' } }

    let(:processed_request) { Substation::Request.new(name, env, processed_input) }
    let(:processed_input)   { Demo::Models::Person.new(:id => nil, :name => 'John') }
    let(:presenter)         { Demo::Presenters::Person.new(processed_input) }
    let(:view)              { Demo::Views::Person.new(presenter) }
    let(:response)          { Substation::Response::Success.new(processed_request, view) }

    it_behaves_like 'an action invocation' do
      let(:action_response) { Substation::Response::Success.new(processed_request, processed_input) }
    end

    it { should eql(response) }
  end

  context 'with an input that produces an application error' do
    let(:input) { { 'name' => 'error' } }

    let(:processed_request) { Substation::Request.new(name, env, processed_input) }
    let(:processed_input)   { Demo::Models::Person.new(:id => nil, :name => 'error') }
    let(:error)             { Demo::Error::ApplicationError.new(processed_input) }
    let(:error_response)    { Substation::Response::Failure.new(processed_request, error) }
    let(:rendered)          { Demo::Renderer::ApplicationError.call(error_response) }
    let(:response)          { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'an action invocation' do
      let(:action_response) { Substation::Response::Failure.new(processed_request, processed_input) }
    end

    it { should eql(response) }
  end

  context 'with an input that raises an exception while processing' do
    let(:input) { { 'name' => 'exception' } }

    let(:processed_request) { Substation::Request.new(name, env, processed_input) }
    let(:processed_input)   { Demo::Models::Person.new(:id => nil, :name => 'exception') }
    let(:failure_data)      { Substation::Chain::FailureData.new(processed_input, RuntimeError.new) }
    let(:error)             { Demo::Error::InternalError.new(failure_data) }
    let(:view)              { Demo::Views::InternalError.new(error) }
    let(:error_response)    { Substation::Response::Failure.new(processed_request, view) }
    let(:rendered)          { Demo::Renderer::InternalError.call(error_response) }
    let(:response)          { Substation::Response::Failure.new(request, rendered) }

    it_behaves_like 'no action invocation'

    it { should eql(response) }
  end

  context 'with invalid input' do
    let(:input) { { 'name' => 'X' } }

    let(:processed_request) { Substation::Request.new(name, env, processed_input) }
    let(:processed_input)   { Demo::Models::Person.new(:id => nil, :name => 'X') }
    let(:error)             { Demo::Error::ValidationError.new(processed_input) }
    let(:error_response)    { Substation::Response::Failure.new(processed_request, error) }
    let(:rendered)          { Demo::Renderer::ValidationError.call(error_response) }
    let(:response)          { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'no action invocation'

    it { should eql(response) }
  end

  context 'with malformed input' do
    let(:input) { { 'evil' => 'params' } }

    let(:error)             { Demo::Error::SanitizationError.new(input) }
    let(:view)              { Demo::Views::SanitizationError.new(error) }
    let(:error_response)    { Substation::Response::Failure.new(request, view) }
    let(:rendered)          { Demo::Renderer::SanitizationError.call(error_response) }
    let(:response)          { Substation::Response::Failure.new(request, rendered) }

    it_behaves_like 'no action invocation'

    it { should eql(response) }
  end

  context 'with input from an unknown user' do
    let(:input) { { 'name' => 'unknown' } }

    let(:processed_request) { Substation::Request.new(name, env, processed_input) }
    let(:processed_input)   { Demo::Models::Person.new(:id => nil, :name => 'unknown') }
    let(:error)             { Demo::Error::AuthenticationError.new(processed_input) }
    let(:error_response)    { Substation::Response::Failure.new(processed_request, error) }
    let(:rendered)          { Demo::Renderer::AuthenticationError.call(error_response) }
    let(:response)          { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'no action invocation'

    it { should eql(response) }
  end

  context 'with input from an unauthorized user' do
    let(:input) { { 'name' => 'forbidden' } }

    let(:processed_request) { Substation::Request.new(name, env, processed_input) }
    let(:processed_input)   { Demo::Models::Person.new(:id => nil, :name => 'forbidden') }
    let(:error)             { Demo::Error::AuthorizationError.new(processed_input) }
    let(:error_response)    { Substation::Response::Failure.new(processed_request, error) }
    let(:rendered)          { Demo::Renderer::AuthorizationError.call(error_response) }
    let(:response)          { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'no action invocation'

    it { should eql(response) }
  end
end
