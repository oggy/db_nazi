module DBNazi
  module MigrationProxy
    def self.included(base)
      base.class_eval do
        alias migrate_without_db_nazi migrate
        alias migrate migrate_with_db_nazi
      end
    end

    def migrate_with_db_nazi(direction)
      action = DBNazi.enabled_for_migration?(migration, version) ? :enable : :disable
      DBNazi.send(action) do
        migrate_without_db_nazi(direction)
      end
    end
  end
end
