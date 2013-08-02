# encoding: utf-8

shared_context 'demo application' do
  let(:request)           { Substation::Request.new(name, env, input) }
  let(:name)              { :create_person }
  let(:env)               { Demo::APP_ENV }

  let(:session_data)      { { 'account_id' => account_id } }

  let(:authorized_id)     { 1 }
  let(:unauthorized_id)   { 2 }
  let(:unknown_id)        { 3 }

  let(:processed_request) { Substation::Request.new(name, env, processed_input) }
  let(:actor)             { Demo::Domain::Actor.coerce(session_data, acting_person) }
  let(:acting_person)     { Demo::Domain::DTO::Person.new(:id => account_id, :name => 'Jane') }

  let(:accepted_input)    { Demo::Core::Input::Accepted.new(actor, person) }
  let(:incomplete_input)  { Demo::Core::Input::Incomplete.new(session_data, incomplete_data) }
  let(:incomplete_data)   { person }

  let(:person)            { Demo::Domain::DTO::Person.new(:id => nil, :name => person_name) }

  let(:error_response)     { Substation::Response::Failure.new(processed_request, error_data) }
  let(:exception_response) { Substation::Response::Exception.new(processed_request, error_data) }
  let(:error_data)         { error }

end
