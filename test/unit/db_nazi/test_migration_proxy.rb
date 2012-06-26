require_relative '../../test_helper'

describe DBNazi::MigrationProxy do
  use_database
  use_temporary_directory "#{ROOT}/test/tmp"
  silence_stdout

  before do
    @original_pwd = Dir.pwd
    Dir.chdir "#{ROOT}/test/tmp"
  end

  after do
    Dir.chdir @original_pwd
  end

  before do
    @migration_proxy = ActiveRecord::MigrationProxy.new("test_migration", 10, "test_migration.rb", nil)
    @migration_class = Class.new(ActiveRecord::Migration) do
      attr_reader :enabled

      def up
        @enabled = DBNazi.enabled
      end
    end
    migration = @migration = @migration_class.new
    @migration_proxy.singleton_class.send(:define_method, :migration) { migration }
  end

  describe "#migrate" do
    it "disables DBNazi when no_nazi is used" do
      @migration_class.no_nazi
      @migration_proxy.migrate(:up)
      @migration.enabled.must_equal false
    end

    describe "when DBNazi.from_version is set" do
      it "disables DBNazi if this migration comes before the minimum version" do
        with_attribute_value DBNazi, :from_version, 11 do
          @migration_proxy.migrate(:up)
          @migration.enabled.must_equal false
        end
      end

      it "does not disable DBNazi if this migration is the minimum version" do
        with_attribute_value DBNazi, :from_version, 10 do
          @migration_proxy.migrate(:up)
          @migration.enabled.must_equal true
        end
      end

      it "does not disable DBNazi if this migration comes after the minimum version" do
        with_attribute_value DBNazi, :from_version, 9 do
          @migration_proxy.migrate(:up)
          @migration.enabled.must_equal true
        end
      end
    end

    it "enables DBNazi otherwise" do
      @migration_proxy.migrate(:up)
      @migration.enabled.must_equal true
    end
  end
end
