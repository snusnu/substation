shared_examples_for 'an action invocation' do
  it_behaves_like 'all invocations'

  it 'notifies all observers' do
    expect(Demo::Core::Observers::LOG_EVENT).to receive(:call).with(action_response).ordered
    expect(Demo::Core::Observers::SEND_EMAIL).to receive(:call).with(action_response).ordered
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
