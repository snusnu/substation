# encoding: utf-8

require 'demo'

describe 'a typical substation application' do
  subject { Demo::Web::HTML::APP.call(name, input) }

  let(:request) { Substation::Request.new(name, env, input) }
  let(:name)    { :create_person }
  let(:env)     { Demo::APP_ENV }

  let(:session_data) { { 'account_id' => account_id } }

  let(:input) {
    {
      'session' => MultiJson.dump(session_data),
      'data'    => MultiJson.dump(data)
    }
  }

  let(:authorized_id)   { 1 }
  let(:unauthorized_id) { 2 }
  let(:unknown_id)      { 3 }

  let(:processed_request) { Substation::Request.new(name, env, processed_input) }

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
    let(:data)       { { 'name' => 'John' } }
    let(:account_id) { authorized_id }

    let(:processed_input) { Demo::Core::Input::Accepted.new(actor, person) }
    let(:actor)           { Demo::Core::Actor.coerce(session_data, acting_person) }
    let(:acting_person)   { Demo::Core::Models::Person.new(:id => account_id, :name => 'Jane') }
    let(:person)          { Demo::Core::Models::Person.new(:id => nil, :name => 'John') }
    let(:presenter)       { Demo::Web::Presenter::Person.new(person) }
    let(:view)            { Demo::Web::Views::Person.new(presenter) }
    let(:response)        { Substation::Response::Success.new(processed_request, view) }

    it_behaves_like 'an action invocation' do
      let(:action_response) { Substation::Response::Success.new(processed_request, person) }
      let(:success_status) { true }
    end
  end

  context 'with an input that produces an application error' do
    let(:data)       { { 'name' => 'error' } }
    let(:account_id) { authorized_id }

    let(:processed_input) { Demo::Core::Input::Accepted.new(actor, person) }
    let(:actor)           { Demo::Core::Actor.coerce(session_data, acting_person) }
    let(:acting_person)   { Demo::Core::Models::Person.new(:id => account_id, :name => 'Jane') }
    let(:person)          { Demo::Core::Models::Person.new(:id => nil, :name => 'error') }
    let(:error)           { Demo::Core::Error::ApplicationError.new(person) }
    let(:error_response)  { Substation::Response::Failure.new(processed_request, error) }
    let(:rendered)        { Demo::Web::Renderer::ApplicationError.call(error_response) }
    let(:response)        { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'an action invocation' do
      let(:action_response) { Substation::Response::Failure.new(processed_request, person) }
      let(:success_status)  { false }
    end
  end

  context 'with an input that raises an exception while processing' do
    let(:data)       { { 'name' => 'exception' } }
    let(:account_id) { authorized_id }

    let(:processed_input) { Demo::Core::Input::Accepted.new(actor, person) }
    let(:actor)           { Demo::Core::Actor.coerce(session_data, acting_person) }
    let(:acting_person)   { Demo::Core::Models::Person.new(:id => account_id, :name => 'Jane') }
    let(:person)          { Demo::Core::Models::Person.new(:id => nil, :name => 'exception') }
    let(:failure_data)    { Substation::Chain::FailureData.new(processed_input, RuntimeError.new) }
    let(:error)           { Demo::Core::Error::InternalError.new(failure_data) }
    let(:view)            { Demo::Web::Views::InternalError.new(error) }
    let(:error_response)  { Substation::Response::Failure.new(processed_request, view) }
    let(:rendered)        { Demo::Web::Renderer::InternalError.call(error_response) }
    let(:response)        { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'no action invocation'
  end

  context 'with invalid input' do
    let(:data)       { { 'name' => 'X' } }
    let(:account_id) { authorized_id }

    let(:processed_input) { Demo::Core::Input::Incomplete.new(session_data, person) }
    let(:person)          { Demo::Core::Models::Person.new(:id => nil, :name => 'X') }
    let(:error)           { Demo::Core::Error::ValidationError.new(person) }
    let(:error_response)  { Substation::Response::Failure.new(processed_request, error) }
    let(:rendered)        { Demo::Web::Renderer::ValidationError.call(error_response) }
    let(:response)        { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'no action invocation'
  end

  context 'with malformed input' do
    let(:data)       { { 'malformed' => 'input' } }
    let(:account_id) { authorized_id }

    let(:processed_input) { Demo::Core::Input::Incomplete.new(session_data, data) }
    let(:error)           { Demo::Web::Error::SanitizationError.new(processed_input) }
    let(:view)            { Demo::Web::Views::SanitizationError.new(error) }
    let(:error_response)  { Substation::Response::Failure.new(processed_request, view) }
    let(:rendered)        { Demo::Web::Renderer::SanitizationError.call(error_response) }
    let(:response)        { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'no action invocation'
  end

  context 'with input from an unknown user' do
    let(:data)       { { 'name' => 'unknown' } }
    let(:account_id) { unknown_id }

    let(:processed_input) { Demo::Core::Input::Incomplete.new(session_data, person) }
    let(:person)          { Demo::Core::Models::Person.new(:id => nil, :name => 'unknown') }
    let(:error)           { Demo::Core::Error::AuthenticationError.new(processed_input) }
    let(:error_response)  { Substation::Response::Failure.new(processed_request, error) }
    let(:rendered)        { Demo::Web::Renderer::AuthenticationError.call(error_response) }
    let(:response)        { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'no action invocation'
  end

  context 'with input from an unauthorized user' do
    let(:data)       { { 'name' => 'forbidden' } }
    let(:account_id) { unauthorized_id }

    let(:processed_input) { Demo::Core::Input::Incomplete.new(session_data, person) }
    let(:person)          { Demo::Core::Models::Person.new(:id => nil, :name => 'forbidden') }
    let(:error)           { Demo::Core::Error::AuthorizationError.new(processed_input) }
    let(:error_response)  { Substation::Response::Failure.new(processed_request, error) }
    let(:rendered)        { Demo::Web::Renderer::AuthorizationError.call(error_response) }
    let(:response)        { Substation::Response::Failure.new(processed_request, rendered) }

    it_behaves_like 'no action invocation'
  end
end
