module DBNazi
  autoload :AbstractAdapter, 'db_nazi/abstract_adapter'
  autoload :TableDefinition, 'db_nazi/table_definition'
  autoload :VERSION, 'db_nazi/version'

  ArgumentError = Class.new(::ArgumentError)
  NullabilityRequired = Class.new(ArgumentError)
  VarcharLimitRequired = Class.new(ArgumentError)
  IndexUniquenessRequired = Class.new(ArgumentError)

  class << self
    attr_accessor :enabled
    attr_accessor :require_varchar_limits
    attr_accessor :require_nullability
    attr_accessor :require_index_uniqueness

    def enabled?(setting)
      @enabled && send(setting)
    end

    def reset
      self.enabled = true
      self.require_varchar_limits   = true
      self.require_nullability      = true
      self.require_index_uniqueness = true
    end
  end

  reset
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.__send__ :include, DBNazi::AbstractAdapter
ActiveRecord::ConnectionAdapters::TableDefinition.__send__ :include, DBNazi::TableDefinition
