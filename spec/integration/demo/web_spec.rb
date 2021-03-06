# encoding: utf-8

require 'spec_helper'

require 'demo/web'

describe 'a typical substation application' do
  subject { object.call(name, input) }

  let(:object) { Demo::Web::HTML::APP }

  include_context 'demo application'
  include_context 'with registered chains'

  let(:input) {
    {
      'session' => MultiJson.dump(session_data),
      'data'    => MultiJson.dump(data)
    }
  }

  let(:data)                        { { 'name' => person_name } }
  let(:rendered_error_response)     { Substation::Response::Failure.new(processed_request, rendered) }
  let(:rendered_exception_response) { Substation::Response::Exception.new(processed_request, rendered) }

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
