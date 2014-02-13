require_relative '../test_helper'

describe DBNazi do
  use_database
  use_temporary_directory "#{ROOT}/test/tmp"
  silence_stdout

  before do
    DBNazi.reset
    @original_pwd = Dir.pwd
    Dir.chdir "#{ROOT}/test/tmp"
  end

  after do
    Dir.chdir @original_pwd
  end

  it "raises an error when there is a careless migration" do
    create_bad_migration(1)
    run_migrations
    errors.size.must_equal 1
  end

  it "only applies nazism to selected migrations" do
    create_bad_migration(1)
    create_good_migration(2)
    DBNazi.from_version = 2
    run_migrations
    errors.size.must_equal 0
  end

  def create_bad_migration(version)
    create_migration(version, :bad)
  end

  def create_good_migration(version)
    create_migration(version, :good)
  end

  def create_migration(version, good_or_bad)
    write_file "#{version}_test_migration_#{version}.rb", <<-EOS
      |class TestMigration#{version} < ActiveRecord::Migration
      |  def up
      |    create_table 'table_#{version}' do |t|
      |      t.boolean :test_column #{good_or_bad == :good ? ', null: true' : ''}
      |    end
      |  end
      |end
    EOS
  end

  def run_migrations
    ActiveRecord::Migrator.migrate('.', nil)
  rescue StandardError => e
    if e.message.include?('[db_nazi]')
      errors << e
    else
      raise
    end
  end

  def errors
    @errors ||= []
  end

  def write_file(name, content)
    open(name, 'w') { |f| f.print content.gsub(/^ *\|/, '') }
  end
end
