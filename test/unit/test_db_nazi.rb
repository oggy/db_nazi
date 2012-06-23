require_relative '../test_helper'

describe DBNazi do
  before do
    DBNazi.reset
  end

  describe ".enable" do
    it "should turn on all feature flags for the duration of the block" do
      DBNazi.enabled = false
      DBNazi.enable do
        DBNazi.enabled?(:require_nullability).must_equal true
        DBNazi.enabled?(:require_varchar_limits).must_equal true
        DBNazi.enabled?(:require_index_uniqueness).must_equal true
      end
      DBNazi.enabled?(:require_nullability).must_equal false
      DBNazi.enabled?(:require_varchar_limits).must_equal false
      DBNazi.enabled?(:require_index_uniqueness).must_equal false
    end

    it "should restore a flag to true if it was already enabled" do
      DBNazi.enabled = true
      DBNazi.enable do
        DBNazi.enabled?(:require_nullability).must_equal true
      end
      DBNazi.enabled?(:require_nullability).must_equal true
    end
  end

  describe ".disable" do
    it "should turn off all feature flags for the duration of the block" do
      DBNazi.enabled = true
      DBNazi.disable do
        DBNazi.enabled?(:require_nullability).must_equal false
        DBNazi.enabled?(:require_varchar_limits).must_equal false
        DBNazi.enabled?(:require_index_uniqueness).must_equal false
      end
      DBNazi.enabled?(:require_nullability).must_equal true
      DBNazi.enabled?(:require_varchar_limits).must_equal true
      DBNazi.enabled?(:require_index_uniqueness).must_equal true
    end

    it "should restore a flag to false if it was already disabled" do
      DBNazi.enabled = false
      DBNazi.disable do
        DBNazi.enabled?(:require_nullability).must_equal false
      end
      DBNazi.enabled?(:require_nullability).must_equal false
    end
  end
end
