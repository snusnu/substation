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
