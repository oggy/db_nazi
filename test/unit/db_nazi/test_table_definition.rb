require_relative '../../test_helper'

describe DBNazi::TableDefinition do
  use_database

  before do
    DBNazi.reset
  end

  describe "#column" do
    it "still creates the column if ok" do
      connection.create_table 'test_table' do |t|
        t.column 'test_column', :boolean, null: true
      end
      connection.column_exists?('test_table', 'test_column', :boolean, null: true).must_equal true
    end

    describe "when nullability is required" do
      use_attribute_value DBNazi, :require_nullability, true

      it "raises a DBNazi::NullabilityRequired if :null is not specified" do
        connection.create_table 'test_table' do |t|
          lambda do
            t.column 'test_column', :boolean
          end.must_raise(DBNazi::NullabilityRequired)
        end
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is true" do
        connection.create_table 'test_table' do |t|
          t.column 'test_column', :boolean, null: true
        end
      end

      it "does not raise a DBNazi::NullabilityRequired if :null is false" do
        connection.create_table 'test_table' do |t|
          t.column 'test_column', :boolean, null: false, default: false
        end
      end
    end

    describe "when nullability is not required" do
      use_attribute_value DBNazi, :require_nullability, false

      it "does not raise a DBNazi::NullabilityRequired if :null is not specified" do
        connection.create_table 'test_table' do |t|
          t.column 'test_column', :boolean
        end
      end
    end

    describe "when varchar limits are required" do
      use_attribute_value DBNazi, :require_varchar_limits, true

      it "raises a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        connection.create_table 'test_table' do |t|
          lambda do
            t.column 'test_column', :string, null: true
          end.must_raise(DBNazi::VarcharLimitRequired)
        end
      end

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is specified for a :string column" do
        connection.create_table 'test_table' do |t|
          t.column 'test_column', :string, limit: 255, null: true
        end
      end
    end

    describe "when varchar limits are not required" do
      use_attribute_value DBNazi, :require_varchar_limits, false

      it "does not raise a DBNazi::VarcharLimitRequired if :limit is not specified for a :string column" do
        connection.create_table 'test_table' do |t|
          t.column 'test_column', :string, null: true
        end
      end
    end
  end
end
