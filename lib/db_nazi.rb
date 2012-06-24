module DBNazi
  autoload :AbstractAdapter, 'db_nazi/abstract_adapter'
  autoload :Migration, 'db_nazi/migration'
  autoload :MigrationProxy, 'db_nazi/migration_proxy'
  autoload :Table, 'db_nazi/table'
  autoload :TableDefinition, 'db_nazi/table_definition'
  autoload :VERSION, 'db_nazi/version'

  ArgumentError = Class.new(::ArgumentError)
  NullabilityRequired = Class.new(ArgumentError)
  VarcharLimitRequired = Class.new(ArgumentError)
  IndexUniquenessRequired = Class.new(ArgumentError)

  class << self
    attr_accessor :enabled
    attr_accessor :from_version
    attr_accessor :require_nullability
    attr_accessor :require_varchar_limits
    attr_accessor :require_index_uniqueness

    def enabled?(setting)
      @enabled && send(setting)
    end

    def enable
      original_enabled = @enabled
      @enabled = true
      begin
        yield
      ensure
        @enabled = original_enabled
      end
    end

    def disable
      original_enabled = @enabled
      @enabled = false
      begin
        yield
      ensure
        @enabled = original_enabled
      end
    end

    def enabled_for_migration?(migration, version)
      return false if !@enabled
      return false if migration.nazi_disabled?
      return false if DBNazi.from_version && DBNazi.from_version > version
      true
    end

    def reset
      self.enabled = true
      self.from_version = nil
      self.require_nullability      = true
      self.require_varchar_limits   = true
      self.require_index_uniqueness = true
    end

    def check_column(type, options)
      if DBNazi.enabled?(:require_nullability) && type != :primary_key
        options.key?(:null) or
          raise NullabilityRequired, "[db_nazi] :null parameter required"
      end
      if DBNazi.enabled?(:require_varchar_limits)
        # AR calls #to_sym on type, so do the same here.
        type.to_sym == :string && !options.key?(:limit) and
          raise VarcharLimitRequired, "[db_nazi] string column requires :limit parameter"
      end
    end

    def check_index(options)
      if DBNazi.enabled?(:require_index_uniqueness)
        options.key?(:unique) or
          raise IndexUniquenessRequired, "[db_nazi] :unique parameter required"
      end
    end
  end

  reset
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.__send__ :include, DBNazi::AbstractAdapter
ActiveRecord::ConnectionAdapters::TableDefinition.__send__ :include, DBNazi::TableDefinition
ActiveRecord::ConnectionAdapters::Table.__send__ :include, DBNazi::Table
ActiveRecord::Migration.__send__ :include, DBNazi::Migration
ActiveRecord::MigrationProxy.__send__ :include, DBNazi::MigrationProxy
