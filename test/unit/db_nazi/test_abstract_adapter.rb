require_relative '../../test_helper'

describe DBNazi::AbstractAdapter do
  use_database

  before do
    DBNazi.reset
    connection.create_table 'test_table'
  end

  describe "#add_column" do
    describe "when nullability is required" do
      use_attribute_value DBNazi, :require_nullability, true

      it "raises a DBNazi::NullabilityRequired if :null is not specified" do
        lambda do
          connection.add_column 'test_table', 'test_column', :boolean
        end.must_raise(DBNazi::NullabilityRequired)
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is true" do
        connection.add_column 'test_table', 'test_column', :boolean, null: true
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is false" do
        connection.add_column 'test_table', 'test_column', :boolean, null: false, default: false
      end
    end

    describe "when nullability is not required" do
      use_attribute_value DBNazi, :require_nullability, false

      it "does not raise a DBNazi::NullabilityRequired if :null is not specified" do
        connection.add_column 'test_table', 'test_column', :boolean
      end
    end

    describe "when varchar limits are required" do
      use_attribute_value DBNazi, :require_varchar_limits, true

      it "raises a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        lambda do
          connection.add_column 'test_table', 'test_column', :string, null: true
        end.must_raise(DBNazi::VarcharLimitRequired)
      end

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is specified for a :string column" do
        connection.add_column 'test_table', 'test_column', :string, limit: 255, null: true
      end
    end

    describe "when varchar limits are not required" do
      use_attribute_value DBNazi, :require_varchar_limits, false

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        connection.add_column 'test_table', 'test_column', :string, null: true
      end
    end
  end

  describe "#change_column" do
    before do
      connection.add_column 'test_table', 'test_column', :boolean, null: false, default: false
    end

    describe "when nullability is required" do
      use_attribute_value DBNazi, :require_nullability, true

      it "raises a DBNazi::NullabilityRequired if :null is not specified" do
        lambda do
          connection.change_column 'test_table', 'test_column', :boolean
        end.must_raise(DBNazi::NullabilityRequired)
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is true" do
        connection.change_column 'test_table', 'test_column', :boolean, null: true
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is false" do
        connection.change_column 'test_table', 'test_column', :boolean, null: false, default: false
      end
    end

    describe "when nullability is not required" do
      use_attribute_value DBNazi, :require_nullability, false

      it "does not raise a DBNazi::NullabilityRequired if :null is not specified" do
        connection.change_column 'test_table', 'test_column', :boolean
      end
    end

    describe "when varchar limits are required" do
      use_attribute_value DBNazi, :require_varchar_limits, true

      it "raises a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        lambda do
          connection.change_column 'test_table', 'test_column', :string, null: true
        end.must_raise(DBNazi::VarcharLimitRequired)
      end

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is specified for a :string column" do
        connection.change_column 'test_table', 'test_column', :string, limit: 255, null: true
      end
    end

    describe "when varchar limits are not required" do
      use_attribute_value DBNazi, :require_varchar_limits, false

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        connection.change_column 'test_table', 'test_column', :string, null: true
      end
    end
  end

  describe "#add_index" do
    before do
      connection.add_column 'test_table', 'test_column', :boolean, null: true
    end

    describe "when index uniqueness is required" do
      use_attribute_value DBNazi, :require_index_uniqueness, true

      it "raises a DBNazi::IndexUniquenessRequired if :unique is not specified for an index" do
        lambda do
          connection.add_index 'test_table', 'test_column'
        end.must_raise(DBNazi::IndexUniquenessRequired)
      end

      it "does not raise a DBNazi::IndexUniquenessRequired if :unique is true for an index" do
        connection.add_index 'test_table', 'test_column', unique: true
      end

      it "does not raise a DBNazi::IndexUniquenessRequired if :unique is false for an index" do
        connection.add_index 'test_table', 'test_column', unique: false
      end
    end

    describe "when index uniqueness is not required" do
      use_attribute_value DBNazi, :require_index_uniqueness, false

      it "does not raise a DBNazi::IndexUniquenessRequired if :unique is not specified for an index" do
        connection.add_index 'test_table', 'test_column'
      end
    end
  end

  describe "#initialize_schema_migrations_table" do
    it "still works" do
      # AR doesn't specify a varchar limit for the version column. Lame.
      connection.initialize_schema_migrations_table
    end
  end
end
