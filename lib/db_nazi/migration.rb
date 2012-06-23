module DBNazi
  module Migration
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        alias migrate_without_db_nazi migrate
        alias migrate migrate_with_db_nazi
      end
    end

    def migrate_with_db_nazi(direction)
      action = DBNazi.enabled_for_migration?(self) ? :enable : :disable
      DBNazi.send(action) do
        migrate_without_db_nazi(direction)
      end
    end

    def nazi_disabled?
      self.class.nazi_disabled?
    end

    module ClassMethods
      def no_nazi
        @nazi_disabled = true
      end

      def nazi_disabled?
        @nazi_disabled
      end
    end
  end
end
