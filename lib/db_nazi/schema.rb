module DBNazi
  module Schema
    def self.included(base)
      base.extend ClassMethods
      base.singleton_class.alias_method_chain :define, :db_nazi
    end

    module ClassMethods
      def define_with_db_nazi(*args, &block)
        DBNazi.disable do
          define_without_db_nazi(*args, &block)
        end
      end
    end
  end
end
