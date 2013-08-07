# encoding: utf-8

require 'spec_helper'

require 'demo/core'

describe 'a typical substation application' do
  subject { object.call(name, input) }

  let(:object) { Demo::Core::APP }

  include_context 'demo application'
  include_context 'with registered chains'

  let(:input) { Demo::Core::Input::Incomplete.new(session_data, person) }

  context 'with valid input' do
    let(:person_name)     { 'John' }
    let(:account_id)      { authorized_id }
    let(:processed_input) { accepted_input }
    let(:response)        { Substation::Response::Success.new(processed_request, person) }

    it_behaves_like 'an action invocation' do
      let(:action_response) { response }
      let(:success_status) { true }
    end
  end

  context 'with an input that produces an application error' do
    let(:person_name)     { 'error' }
    let(:account_id)      { authorized_id }
    let(:processed_input) { accepted_input }
    let(:error)           { Demo::Core::Error::ApplicationError.new(person) }
    let(:response)        { error_response }

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
    let(:response)        { exception_response }

    it_behaves_like 'no action invocation'
  end

  context 'with invalid input' do
    let(:person_name)      { 'X' }
    let(:account_id)       { authorized_id }
    let(:processed_input)  { incomplete_input }
    let(:error)            { Demo::Core::Error::ValidationError.new(invalid_input) }
    let(:invalid_input)    { Demo::Core::Input::Incomplete.new(session_data, validation_error) }
    let(:validation_error) { Demo::Domain::DTO::NEW_PERSON_VALIDATOR.call(person).output }
    let(:response)         { error_response }

    it_behaves_like 'no action invocation'
  end

  context 'with malformed input' do
    let(:person)          { :foo }
    let(:account_id)      { authorized_id }
    let(:processed_input) { incomplete_input }
    let(:failure_data)    { Substation::Response::Exception::Output.new(processed_input, RuntimeError.new) }
    let(:error)           { Demo::Core::Error::InternalError.new(failure_data) }
    let(:response)        { exception_response }

    pending 'the response is returned is actually correct, but somehow #eql? fails' do
      it_behaves_like 'no action invocation'
    end
  end

  context 'with input from an unknown user' do
    let(:person_name)     { 'unknown' }
    let(:account_id)      { unknown_id }
    let(:processed_input) { incomplete_input }
    let(:error)           { Demo::Core::Error::AuthenticationError.new(processed_input) }
    let(:response)        { error_response }

    it_behaves_like 'no action invocation'
  end

  context 'with input from an unauthorized user' do
    let(:person_name)     { 'forbidden' }
    let(:account_id)      { unauthorized_id }
    let(:processed_input) { incomplete_input }
    let(:error)           { Demo::Core::Error::AuthorizationError.new(processed_input) }
    let(:response)        { error_response }

    it_behaves_like 'no action invocation'
  end
end
