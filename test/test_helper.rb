$:.unshift File.expand_path('../lib', File.dirname(__FILE__))
ROOT = File.expand_path('..', File.dirname(__FILE__))

require 'minitest/spec'
require 'yaml'
require 'active_record'
require 'temporaries'
require 'debugger'
require 'db_nazi'

ADAPTER = ENV['DB_NAZI_ADAPTER'] || 'sqlite3'
CONFIG = YAML.load_file("#{ROOT}/test/database.yml")[ADAPTER].merge(adapter: ADAPTER)
if ADAPTER =~ /sqlite/
  ActiveRecord::Base.establish_connection(CONFIG)
else
  ActiveRecord::Base.establish_connection(CONFIG.merge('database' => nil))
end

MiniTest::Spec.class_eval do
  def recreate_database
    drop_database
    create_database
  end

  def connection
    ActiveRecord::Base.connection
  end

  def create_database
    unless ADAPTER =~ /sqlite/
      connection.create_database CONFIG['database']
    end
    ActiveRecord::Base.establish_connection(CONFIG)
  end

  def drop_database
    unless ADAPTER =~ /sqlite/
      connection.drop_database CONFIG['database']
    end
  end

  def self.use_database
    before { recreate_database }
    after { drop_database }
  end
end
