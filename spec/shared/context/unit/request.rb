# encoding: utf-8

shared_context 'Request#initialize' do
  let(:request) { Request.new(name, env, input) }
  let(:name)    { double }
  let(:env)     { double }
  let(:input)   { double }
end
