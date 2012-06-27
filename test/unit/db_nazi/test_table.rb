require_relative '../../test_helper'

describe DBNazi::TableDefinition do
  use_database

  before do
    DBNazi.reset
  end

  describe "#column" do
    before do
      connection.create_table 'test_table'
    end

    it "still creates the column if ok" do
      connection.change_table 'test_table', bulk: true do |t|
        t.column 'test_column', :boolean, null: true
      end
      connection.column_exists?('test_table', 'test_column', :boolean, null: true).must_equal true
    end

    describe "when nullability is required" do
      use_attribute_value DBNazi, :require_nullability, true

      it "raises a DBNazi::NullabilityRequired if :null is not specified" do
        connection.change_table 'test_table', bulk: true do |t|
          lambda do
            t.column 'test_column', :boolean
          end.must_raise(DBNazi::NullabilityRequired)
        end
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is true" do
        connection.change_table 'test_table', bulk: true do |t|
          t.column 'test_column', :boolean, null: true
        end
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is false" do
        connection.change_table 'test_table', bulk: true do |t|
          t.column 'test_column', :boolean, null: false, default: false
        end
      end
    end

    describe "when nullability is not required" do
      use_attribute_value DBNazi, :require_nullability, false

      it "does not raise a DBNazi::NullabilityRequired if :null is not specified" do
        connection.change_table 'test_table', bulk: true do |t|
          t.column 'test_column', :boolean
        end
      end
    end

    describe "when varchar limits are required" do
      use_attribute_value DBNazi, :require_varchar_limits, true

      it "raises a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        connection.change_table 'test_table', bulk: true do |t|
          lambda do
            t.column 'test_column', :string, null: true
          end.must_raise(DBNazi::VarcharLimitRequired)
        end
      end

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is specified for a :string column" do
        connection.change_table 'test_table', bulk: true do |t|
          t.column 'test_column', :string, limit: 255, null: true
        end
      end
    end

    describe "when varchar limits are not required" do
      use_attribute_value DBNazi, :require_varchar_limits, false

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        connection.change_table 'test_table', bulk: true do |t|
          t.column 'test_column', :string, null: true
        end
      end
    end
  end

  describe "#index" do
    before do
      connection.create_table 'test_table' do |t|
        t.column 'test_column', :boolean, null: true
      end
    end

    it "still creates the index if ok" do
      connection.change_table 'test_table', bulk: true do |t|
        t.index 'test_column', unique: false
      end
      connection.index_exists?('test_table', 'test_column', unique: false).must_equal true
    end

    describe "when index uniqueness is required" do
      use_attribute_value DBNazi, :require_index_uniqueness, true

      it "raises a DBNazi::IndexUniquenessRequired if :unique is not specified for an index" do
        connection.change_table 'test_table', bulk: true do |t|
          lambda do
            t.index 'test_column'
          end.must_raise(DBNazi::IndexUniquenessRequired)
        end
      end

      it "does not raise a DBNazi::IndexUniquenessRequired if :unique is true for an index" do
        connection.change_table 'test_table', bulk: true do |t|
          t.index 'test_column', unique: true
        end
      end

      it "does not raise a DBNazi::IndexUniquenessRequired if :unique is false for an index" do
        connection.change_table 'test_table', bulk: true do |t|
          t.index 'test_column', unique: false
        end
      end
    end

    describe "when index uniqueness is not required" do
      use_attribute_value DBNazi, :require_index_uniqueness, false

      it "does not raise a DBNazi::IndexUniquenessRequired if :unique is not specified for an index" do
        connection.change_table 'test_table', bulk: true do |t|
          t.index 'test_column'
        end
      end
    end
  end

  describe "#change" do
    before do
      connection.create_table 'test_table' do |t|
        t.column 'test_column', :boolean, null: true
      end
    end

    it "still changes the column if ok" do
      connection.change_table 'test_table', bulk: true do |t|
        t.change 'test_column', :boolean, null: false, default: false
      end
      connection.column_exists?('test_table', 'test_column', :boolean, null: false, default: false).must_equal true
    end

    describe "when nullability is required" do
      use_attribute_value DBNazi, :require_nullability, true

      it "raises a DBNazi::NullabilityRequired if :null is not specified" do
        connection.change_table 'test_table', bulk: true do |t|
          lambda do
            t.change 'test_column', :boolean
          end.must_raise(DBNazi::NullabilityRequired)
        end
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is true" do
        connection.change_table 'test_table', bulk: true do |t|
          t.change 'test_column', :boolean, null: true
        end
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is false" do
        connection.change_table 'test_table', bulk: true do |t|
          t.change 'test_column', :boolean, null: false, default: false
        end
      end
    end

    describe "when nullability is not required" do
      use_attribute_value DBNazi, :require_nullability, false

      it "does not raise a DBNazi::NullabilityRequired if :null is not specified" do
        connection.change_table 'test_table', bulk: true do |t|
          t.change 'test_column', :boolean
        end
      end
    end

    describe "when varchar limits are required" do
      use_attribute_value DBNazi, :require_varchar_limits, true

      it "raises a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        connection.change_table 'test_table', bulk: true do |t|
          lambda do
            t.change 'test_column', :string, null: true
          end.must_raise(DBNazi::VarcharLimitRequired)
        end
      end

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is specified for a :string column" do
        connection.change_table 'test_table', bulk: true do |t|
          t.change 'test_column', :string, limit: 255, null: true
        end
      end
    end

    describe "when varchar limits are not required" do
      use_attribute_value DBNazi, :require_varchar_limits, false

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        connection.change_table 'test_table', bulk: true do |t|
          t.change 'test_column', :string, null: true
        end
      end
    end
  end
end
