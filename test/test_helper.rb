$:.unshift File.expand_path('../lib', File.dirname(__FILE__))
ROOT = File.expand_path('..', File.dirname(__FILE__))

require 'minitest/spec'
require 'yaml'
require 'active_record'
require 'temporaries'
require 'db_nazi'

ADAPTER = ENV['DB_NAZI_ADAPTER'] || 'sqlite3'
CONFIG = YAML.load_file("#{ROOT}/test/database.yml")[ADAPTER].merge(adapter: ADAPTER)
case ADAPTER
when /sqlite/
  ActiveRecord::Base.establish_connection(CONFIG)
when /postgres/
  ActiveRecord::Base.establish_connection(CONFIG.merge('database' => 'postgres'))
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
    case ADAPTER
    when /sqlite/
      # Nothing to do - in-memory database.
    when /postgres/
      # Postgres barfs if you drop the selected database.
      ActiveRecord::Base.establish_connection(CONFIG.merge('database' => 'postgres'))
      connection.drop_database CONFIG['database']
    else
      connection.drop_database CONFIG['database']
    end
  end

  def self.use_database
    include Module.new {
      extend MiniTest::Spec::DSL
      before { recreate_database }
      after { drop_database }
    }
  end

  # Migrations use Kernel.puts. Lame. This shuts them up.
  def self.silence_stdout
    out = Class.new { def puts(*); end; def write(*) end; def flush(*) end }.new
    use_global_value :stdout, out
  end
end
