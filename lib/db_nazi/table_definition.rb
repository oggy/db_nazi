module DBNazi
  module TableDefinition
    def self.included(base)
      base.class_eval do
        alias column_without_db_nazi column
        alias column column_with_db_nazi
      end
    end

    def column_with_db_nazi(name, type, options = {})
      DBNazi.check_column(type, options)
      column_without_db_nazi(name, type, options)
    end
  end
end
