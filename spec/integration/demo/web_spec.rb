# encoding: utf-8

require 'spec_helper'

require 'demo/web'

describe 'a typical substation application' do
  subject { Demo::Web::HTML::APP.call(name, input) }

  include_context 'demo application'

  let(:input) {
    {
      'session' => MultiJson.dump(session_data),
      'data'    => MultiJson.dump(data)
    }
  }

  let(:data)                        { { 'name' => person_name } }
  let(:rendered_error_response)     { Substation::Response::Failure.new(processed_request, rendered) }
  let(:rendered_exception_response) { Substation::Response::Exception.new(processed_request, rendered) }

  shared_examples_for 'all invocations' do
    it { should eql(response) }

    it 'indicates success via #success?' do
      expect(subject.success?).to be(success_status)
    end

    it 'provides the processed input in Response#input' do
      expect(subject.input).to eql(processed_input)
    end
  end

  shared_examples_for 'an action invocation' do
    it_behaves_like 'all invocations'

    it 'notifies all observers' do
      expect(Demo::Core::Observers::LOG_EVENT).to receive(:call).with(action_response)
      expect(Demo::Core::Observers::SEND_EMAIL).to receive(:call).with(action_response)
      subject
    end
  end

  shared_examples_for 'no action invocation' do
    let(:success_status) { false }

    it_behaves_like 'all invocations'

    it 'does not notify any observers' do
      expect(Demo::Core::Observers::LOG_EVENT).to_not receive(:call)
      expect(Demo::Core::Observers::SEND_EMAIL).to_not receive(:call)
      subject
    end
  end

  context 'with registered chains' do
    let(:input)      { mock }
    let(:account_id) { authorized_id }

    it 'lists all the registered names' do
      expect(Demo::Web::HTML::APP.action_names).to eql(Set[ :create_person ])
    end
  end

  context 'with valid input' do
    let(:person_name)     { 'John' }
    let(:account_id)      { authorized_id }
    let(:processed_input) { accepted_input }
    let(:presenter)       { Demo::Web::Presenter::Person.new(person) }
    let(:view)            { Demo::Web::Views::Person.new(presenter) }
    let(:response)        { Substation::Response::Success.new(processed_request, view) }

    it_behaves_like 'an action invocation' do
      let(:action_response) { Substation::Response::Success.new(processed_request, person) }
      let(:success_status) { true }
    end
  end

  context 'with an input that produces an application error' do
    let(:person_name)     { 'error' }
    let(:account_id)      { authorized_id }
    let(:processed_input) { accepted_input }
    let(:error)           { Demo::Core::Error::ApplicationError.new(person) }
    let(:rendered)        { Demo::Web::Renderer::ApplicationError.call(error_response) }
    let(:response)        { rendered_error_response }

    it_behaves_like 'an action invocation' do
      let(:action_response) { Substation::Response::Failure.new(processed_request, person) }
      let(:success_status)  { false }
    end
  end

  context 'with an input that raises an exception while processing' do
    let(:person_name)     { 'exception' }
    let(:account_id)      { authorized_id }
    let(:processed_input) { accepted_input }
    let(:failure_data)    { Substation::Response::Exception::Output.new(processed_input, RuntimeError.new) }
    let(:error)           { Demo::Core::Error::InternalError.new(failure_data) }
    let(:view)            { Demo::Web::Views::InternalError.new(error) }
    let(:error_data)      { view }
    let(:rendered)        { Demo::Web::Renderer::InternalError.call(error_response) }
    let(:response)        { rendered_exception_response }

    it_behaves_like 'no action invocation'
  end

  context 'with invalid input' do
    let(:person_name)     { 'X' }
    let(:account_id)      { authorized_id }
    let(:processed_input) { incomplete_input }
    let(:error)           { Demo::Core::Error::ValidationError.new(person) }
    let(:rendered)        { Demo::Web::Renderer::ValidationError.call(error_response) }
    let(:response)        { rendered_error_response }

    it_behaves_like 'no action invocation'
  end

  context 'with malformed input' do
    let(:data)            { { 'malformed' => 'input' } }
    let(:account_id)      { authorized_id }
    let(:processed_input) { incomplete_input }
    let(:incomplete_data) { data }
    let(:error)           { Demo::Web::Error::SanitizationError.new(processed_input) }
    let(:view)            { Demo::Web::Views::SanitizationError.new(error) }
    let(:error_data)      { view }
    let(:rendered)        { Demo::Web::Renderer::SanitizationError.call(error_response) }
    let(:response)        { rendered_error_response }

    it_behaves_like 'no action invocation'
  end

  context 'with input from an unknown user' do
    let(:person_name)     { 'unknown' }
    let(:account_id)      { unknown_id }
    let(:processed_input) { incomplete_input }
    let(:error)           { Demo::Core::Error::AuthenticationError.new(processed_input) }
    let(:rendered)        { Demo::Web::Renderer::AuthenticationError.call(error_response) }
    let(:response)        { rendered_error_response }

    it_behaves_like 'no action invocation'
  end

  context 'with input from an unauthorized user' do
    let(:person_name)     { 'forbidden' }
    let(:account_id)      { unauthorized_id }
    let(:processed_input) { incomplete_input }
    let(:error)           { Demo::Core::Error::AuthorizationError.new(processed_input) }
    let(:rendered)        { Demo::Web::Renderer::AuthorizationError.call(error_response) }
    let(:response)        { rendered_error_response }

    it_behaves_like 'no action invocation'
  end
end
