# encoding: utf-8

require 'spec_helper'

module App

  class Database
    include Concord.new(:relations)

    def [](relation_name)
      Relation.new(relations[relation_name])
    end

    class Relation
      include Concord.new(:tuples)
      include Enumerable

      def each(&block)
        return to_enum unless block_given?
        tuples.each(&block)
        self
      end

      def all
        tuples
      end

      def insert(tuple)
        self.class.new(tuples + [tuple])
      end
    end
  end

  module Models

    class Person
      include Concord.new(:attributes)

      def id
        attributes[:id]
      end

      def name
        attributes[:name]
      end
    end
  end # module Models

  class Environment
    include Concord.new(:storage)
    include Adamantium::Flat

    attr_reader :storage
  end

  class Storage
    include Concord.new(:db)
    include Adamantium::Flat

    include Models

    def list_people
      db[:people].all.map { |tuple| Person.new(tuple) }
    end

    def load_person(id)
      Person.new(db[:people].select { |tuple| tuple[:id] == id }.first)
    end

    def create_person(person)
      relation = db[:people].insert(:id => person.id, :name => person.name)
      relation.map { |tuple| Person.new(tuple) }
    end
  end

  class App
    include Concord.new(:dispatcher)
    include Adamantium::Flat

    def call(name, input = nil)
      dispatcher.call(name, input)
    end
  end

  # Base class for all actions
  #
  # @abstract
  class Action

    include AbstractType
    include Adamantium::Flat

    def self.call(request)
      new(request).call
    end

    def initialize(request)
      @request = request
      @env     = @request.env
      @input   = @request.input
    end

    abstract_method :call

    private

    attr_reader :request
    attr_reader :env
    attr_reader :input

    def db
      @env.storage
    end

    def success(data)
      @request.success(data)
    end

    def error(data)
      @request.error(data)
    end
  end

  module Actions
    class ListPeople < Action

      def call
        success(db.list_people)
      end
    end

    class LoadPerson < Action
      def initialize(request)
        super
        @id = input
      end

      def call
        success(db.load_person(@id))
      end
    end

    class CreatePerson < Action

      def initialize(request)
        super
        @person = input
      end

      def call
        success(db.create_person(@person))
      end
    end

  end # module Actions

  module Observers
    LogEvent  = Class.new { def self.call(response); end }
    SendEmail = Class.new { def self.call(response); end }
  end

  DB = Database.new({
    :people => [{
      :id   => 1,
      :name => 'John'
    }]
  })

  actions = {
    :list_people   => Actions::ListPeople,
    :load_person   => Actions::LoadPerson,
    :create_person => {
      :action   => Actions::CreatePerson,
      :observer => [
        Observers::LogEvent,
        Observers::SendEmail
      ]
    }
  }

  storage    = Storage.new(DB)
  env        = Environment.new(storage)
  dispatcher = Substation::Dispatcher.coerce(actions, env)

  APP = App.new(dispatcher)
end

describe App::APP, '#call' do

  context "when dispatching an action" do
    subject { object.call(action, input) }

    let(:object)   { described_class }
    let(:request)  { Substation::Request.new(env, input) }
    let(:env)      { App::Environment.new(storage) }
    let(:storage)  { App::Storage.new(App::DB) }
    let(:response) { Substation::Response::Success.new(request, output) }

    let(:john) { App::Models::Person.new(:id => 1, :name => 'John') }
    let(:jane) { App::Models::Person.new(:id => 2, :name => 'Jane') }

    context "with no input data" do
      let(:action)  { :list_people }
      let(:input)   { nil }
      let(:output)  { [ john ] }

      it { should eql(response) }
    end

    context "with input data" do
      context "and no observer" do
        let(:action) { :load_person }
        let(:input)  { 1 }
        let(:output) { john }

        it { should eq(response) }
      end

      context "and observers" do
        let(:action)   { :create_person }
        let(:input)    { jane }
        let(:output)   { [ john, jane ] }

        before do
          App::Observers::LogEvent.should_receive(:call).with(response).ordered
          App::Observers::SendEmail.should_receive(:call).with(response).ordered
        end

        it { should eql(response) }
      end

    end
  end
end
