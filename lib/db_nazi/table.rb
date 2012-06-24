module DBNazi
  module Table
    def self.included(base)
      base.class_eval do
        alias_method_chain :column, :db_nazi
        alias_method_chain :index, :db_nazi
        alias_method_chain :change, :db_nazi
      end
    end

    def column_with_db_nazi(column_name, type, options = {})
      DBNazi.check_column(type, options)
      column_without_db_nazi(column_name, type, options)
    end

    def index_with_db_nazi(column_name, options = {})
      DBNazi.check_index(options)
      index_without_db_nazi(column_name, options)
    end

    def change_with_db_nazi(column_name, type, options = {})
      DBNazi.check_column(type, options)
      change_without_db_nazi(column_name, type, options)
    end
  end
end
