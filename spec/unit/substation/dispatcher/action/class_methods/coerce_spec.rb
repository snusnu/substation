# encoding: utf-8

require 'spec_helper'

describe Dispatcher::Action, '.coerce' do

  subject { described_class.coerce(config) }

  let(:action)  { Spec::Action::Success }
  let(:coerced) { Dispatcher::Action.new(action, observer) }

  context "when config is a hash" do
    context "and coercion is possible" do

      let(:config) {{
          :action   => action,
          :observer => observer_value
      }}

      before do
        Observer.should_receive(:coerce).with(observer_value).and_return(observer)
        Utils.should_receive(:coerce_callable).with(action).and_return(action)
      end

      context 'with an action and an observer' do
        let(:observer_value) { observer }
        let(:observer)       { Spec::Observer }

        it { should eql(coerced) }
      end

      context 'with an action and no observer' do
        let(:observer_value) { nil }
        let(:observer)       { Observer::NULL }

        it { should eql(coerced) }
      end
    end

    context 'with no action' do
      let(:config) { {} }

      specify {
        expect { subject }.to raise_error(described_class::MissingHandlerError)
      }
    end
  end

  context "when config is no hash" do
    let(:config)         { action }
    let(:observer_value) { nil }
    let(:observer)       { Observer::NULL }

    before do
      Observer.should_receive(:coerce).with(observer_value).and_return(observer)
      Utils.should_receive(:coerce_callable).with(config).and_return(action)
    end

    it { should eql(coerced) }
  end
end
