module DBNazi
  module TableDefinition
    def self.included(base)
      base.class_eval do
        alias column_without_db_nazi column
        alias column column_with_db_nazi
      end
    end

    def column_with_db_nazi(name, type, options = {})
      if DBNazi.enabled?(:require_nullability) && type != :primary_key
        options.key?(:null) or
          raise NullabilityRequired, "[db_nazi] :null parameter required"
      end
      if DBNazi.enabled?(:require_varchar_limits)
        # AR calls #to_sym on type, so do the same here.
        type.to_sym == :string && !options.key?(:limit) and
          raise VarcharLimitRequired, "[db_nazi] string column requires :limit parameter"
      end
      column_without_db_nazi(name, type, options)
    end
  end
end
