# encoding: utf-8

require 'spec_helper'

describe Response::API::Failure do
  describe '#success?' do
    subject { object.success? }

    context 'in case of failure' do

      let(:object) { Class.new { include Response::API::Failure }.new }

      it { should be(false) }
    end

    context 'in case of success' do
      let(:object) { Class.new { include Response::API::Success }.new }

      it { should be(true) }
    end
  end
end
