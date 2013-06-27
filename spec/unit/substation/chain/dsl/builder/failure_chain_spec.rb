# encoding: utf-8

require 'spec_helper'

describe "Failure chain construction" do
  subject { dsl.new(processors, &block) }

  let(:registry) {{
    :test => { :class => Spec::Processor,    :block => default_block },
    :wrap => { :class => Processor::Wrapper, :block => nil }
  }}

  let(:dsl)        { Chain::DSL::Builder.call(registry) }
  let(:processors) { [] }
  let(:block)      { lambda { |_| test(Spec::FAKE_HANDLER) } }

  let(:processor)     { Spec::Processor.new(failure_chain, Spec::FAKE_HANDLER) }
  let(:failure_chain) { dsl.build(default_block, custom_block) }

  context "when no default failure chain was registered" do
    let(:default_block) { nil }

    context "and no custom failure chain was registered" do
      let(:block)        { lambda { |_| test(Spec::FAKE_HANDLER) } }
      let(:custom_block) { nil }

      it "should register and instantiate processors" do
        expect(subject.processors).to include(processor)
      end
    end

    context "and a custom failure chain was registered" do
      let(:block) {
        lambda { |_|
          test(Spec::FAKE_HANDLER) { wrap(Spec::FAKE_HANDLER) }
        }
      }

      let(:custom_block) { lambda { |_| wrap(Spec::FAKE_HANDLER) } }

      it "should register and instantiate processors" do
        expect(subject.processors).to include(processor)
      end
    end
  end

  context "when a default failure chain was registered" do
    let(:default_block) { lambda { |_| wrap(Spec::FAKE_HANDLER) } }

    context "and no custom failure chain was registered" do
      let(:block)        { lambda { |_| test(Spec::FAKE_HANDLER) } }
      let(:custom_block) { nil }

      it "should register and instantiate processors" do
        expect(subject.processors).to include(processor)
      end
    end

    context "and a custom failure chain was registered" do
      let(:block) {
        lambda { |_|
          test(Spec::FAKE_HANDLER) { wrap(Spec::FAKE_HANDLER) }
        }
      }

      let(:custom_block) { lambda { |_| wrap(Spec::FAKE_HANDLER) } }

      it "should register and instantiate processors" do
        expect(subject.processors).to include(processor)
      end
    end
  end
end
