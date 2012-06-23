require_relative '../../test_helper'

describe DBNazi::Migration do
  before do
    @migration_class = Class.new(ActiveRecord::Migration) do
      def initialize(*)
        super
        self.version = 10
      end

      attr_reader :enabled

      def up
        @enabled = DBNazi.enabled
      end
    end
  end

  describe "#migrate" do
    # Migrations use Kernel.puts. Lame.
    out = Class.new { def write(*) end }.new
    use_global_value :stdout, out

    it "disables DBNazi when no_nazi is used" do
      @migration_class.no_nazi
      migration = @migration_class.new
      migration.migrate(:up)
      migration.enabled.must_equal false
    end

    describe "when DBNazi.from_version is set" do
      it "disables DBNazi if this migration comes before the minimum version" do
        with_attribute_value DBNazi, :from_version, 11 do
          migration = @migration_class.new
          migration.migrate(:up)
          migration.enabled.must_equal false
        end
      end

      it "does not disable DBNazi if this migration is the minimum version" do
        with_attribute_value DBNazi, :from_version, 10 do
          migration = @migration_class.new
          migration.migrate(:up)
          migration.enabled.must_equal true
        end
      end

      it "does not disable DBNazi if this migration comes after the minimum version" do
        with_attribute_value DBNazi, :from_version, 9 do
          migration = @migration_class.new
          migration.migrate(:up)
          migration.enabled.must_equal true
        end
      end
    end

    it "enables DBNazi otherwise" do
      migration = @migration_class.new
      migration.migrate(:up)
      migration.enabled.must_equal true
    end
  end
end
