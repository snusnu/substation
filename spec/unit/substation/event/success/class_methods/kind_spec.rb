# encoding: utf-8

require 'spec_helper'

describe Event::Success, '.kind' do

  subject { described_class.kind }

  it { should be(:success) }
end
