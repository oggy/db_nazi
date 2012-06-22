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

def recreate_database(name)
  drop_database(name)
  case ADAPTER
  when 'sqlite3'
    ActiveRecord::Base.establish_connection(CONNECTION)
  when 'mysql2', 'postgresql'
    ActiveRecord::Base.connection.create_database(name)
  else
    raise "can't create database for #{ADAPTER}"
  end
end

def drop_database(name)
  case ADAPTER
  when 'sqlite3'
  when 'mysql2', 'postgresql'
    ActiveRecord::Base.connection.drop_database(name)
  else
    raise "can't drop database for #{ADAPTER}"
  end
end
