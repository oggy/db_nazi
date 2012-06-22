module DBNazi
  module AbstractAdapter
    def add_column(table_name, column_name, type, options = {})
      if DBNazi.enabled?(:require_nullability)
        options.key?(:null) or
          raise NullabilityRequired, "[db_nazi] :null parameter required"
      end
      if DBNazi.enabled?(:require_varchar_limits)
        # AR calls #to_sym on type, so do the same here.
        type.to_sym == :string && !options.key?(:limit) and
          raise VarcharLimitRequired, "[db_nazi] string column requires :limit parameter"
      end
      super
    end

    def add_index(table_name, column_name, options = {})
      if DBNazi.enabled?(:require_index_uniqueness)
        options.key?(:unique) or
          raise IndexUniquenessRequired, "[db_nazi] :unique parameter required"
      end
    end
  end
end
