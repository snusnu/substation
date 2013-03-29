# encoding: utf-8

require 'spec_helper'

describe Action, '.request_model' do

  let(:object)  { Class.new(described_class) }
  let(:klass)   { mock }

  context "when used as a writer" do
    subject { object.request_model(klass) }

    it { should equal(klass) }
  end

  context "when used as a reader" do
    context "and no request model has been set before" do
      subject { object.request_model }

      it { should be(nil) }
    end

    context "and a request model has been set before" do
      subject { object.request_model }

      before { object.request_model(klass) }

      it { should equal(klass) }
    end
  end
end
