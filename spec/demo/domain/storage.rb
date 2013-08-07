# encoding: utf-8

class Demo
  module Domain

    class Storage
      include Concord::Public.new(:db)

      INITIAL_SEQUENCE_VALUE = 2 # Demo::DATABASE is using 1 and 2

      @sequence = INITIAL_SEQUENCE_VALUE

      def self.next_key
        @sequence += 1
      end

      def create_person(person)
        db[:accounts] << new_person_tuple(next_key, person)
        person # make specs easier by not testing "server generated" keys
      end

      def load_person(account_id)
        tuple = db[:accounts].detect { |person| person[:id] == account_id }
        tuple ? new_person_instance(tuple) : nil
      end

      def load_account_privilege(account_id, privilege_name)
        db[:account_privileges].detect { |account_privilege|
          account_privilege[:account_id] == account_id &&
          account_privilege[:privilege_name] == privilege_name
        }
      end

      private

      def new_person_tuple(id, person)
        { :id => id, :name => person.name, :privileges => [] }
      end

      def new_person_instance(tuple)
        DTO::Person.new(:id => tuple[:id], :name => tuple[:name])
      end

      def next_key
        self.class.next_key
      end
    end
  end
end
