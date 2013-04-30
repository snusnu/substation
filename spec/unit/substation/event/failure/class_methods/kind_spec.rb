# encoding: utf-8

require 'spec_helper'

describe Event::Failure, '.kind' do

  subject { described_class.kind }

  it { should be(:failure) }
end
