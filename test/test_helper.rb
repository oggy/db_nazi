$:.unshift File.expand_path('../lib', File.dirname(__FILE__))
ROOT = File.expand_path('..', File.dirname(__FILE__))

require 'minitest/spec'
require 'yaml'
require 'active_record'
require 'temporaries'
require 'debugger'
require 'db_nazi'

ADAPTER = ENV['DBNAZI_ADAPTER'] || 'sqlite3'
CONNECTION = YAML.load_file("#{ROOT}/test/database.yml")[ADAPTER].merge(adapter: ADAPTER)
ActiveRecord::Base.establish_connection(CONNECTION)

MiniTest::Spec.class_eval do
  def recreate_database
    drop_database
    case ADAPTER
    when 'sqlite3'
      ActiveRecord::Base.establish_connection(CONNECTION)
    when 'mysql2', 'postgresql'
      ActiveRecord::Base.connection.create_database 'db_nazi_test'
    else
      raise "can't create database for #{ADAPTER}"
    end
  end

  def drop_database
    case ADAPTER
    when 'sqlite3'
    when 'mysql2', 'postgresql'
      ActiveRecord::Base.connection.drop_database 'db_nazi_test'
    else
      raise "can't drop database for #{ADAPTER}"
    end
  end

  def connection
    ActiveRecord::Base.connection
  end

  def self.use_database
    before { recreate_database }
    after { drop_database }
  end
end
