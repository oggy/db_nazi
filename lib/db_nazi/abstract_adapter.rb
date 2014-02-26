module DBNazi
  module AbstractAdapter
    extend ActiveSupport::Concern

    module ClassMethods
      def new(*)
        # We mix into singleton classes here, since some adapters define these
        # methods directly in their classes (e.g. SQLite3Adapter#change_column),
        # and we don't want to load these classes just to monkeypatch them.
        super.tap do |adapter|
          adapter.extend Adapter
        end
      end
    end

    module Adapter
      def add_column(table_name, column_name, type, options = {})
        DBNazi.check_column(type, options)
        super
      end

      def add_index(table_name, column_name, options = {})
        DBNazi.check_index(options)
        super
      end

      def change_column(table_name, column_name, type, options = {})
        DBNazi.check_column(type, options)
        super
      end

      def change_column_default(table_name, column_name, default)
        original_nullability = DBNazi.require_nullability
        begin
          DBNazi.require_nullability = false
          return_val = super
        ensure
          DBNazi.require_nullability = original_nullability
          return_val
        end
      end

      def create_table(name, *)
        if name.to_s == ActiveRecord::Migrator.schema_migrations_table_name.to_s
          DBNazi.disable { super }
        else
          super
        end
      end
    end
  end
end
