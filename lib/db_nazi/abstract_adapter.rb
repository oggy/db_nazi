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
        nazi_column_options(type, options)
        super
      end

      def add_index(table_name, column_name, options = {})
        if DBNazi.enabled?(:require_index_uniqueness)
          options.key?(:unique) or
            raise IndexUniquenessRequired, "[db_nazi] :unique parameter required"
        end
      end

      def create_table(name, *)
        if name.to_s == ActiveRecord::Migrator.schema_migrations_table_name.to_s
          DBNazi.disable { super }
        else
          super
        end
      end

      def change_column(table_name, column_name, type, options = {})
        nazi_column_options(type, options)
        super
      end

      def nazi_column_options(type, options)
        if DBNazi.enabled?(:require_nullability)
          options.key?(:null) or
            raise NullabilityRequired, "[db_nazi] :null parameter required"
        end
        if DBNazi.enabled?(:require_varchar_limits)
          # AR calls #to_sym on type, so do the same here.
          type.to_sym == :string && !options.key?(:limit) and
            raise VarcharLimitRequired, "[db_nazi] string column requires :limit parameter"
        end
      end
    end
  end
end
