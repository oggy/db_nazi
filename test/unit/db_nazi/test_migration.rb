require_relative '../../test_helper'

describe DBNazi::Migration do
  describe "#nazi_disabled?" do
    it "is true if no_nazi was called on the migration class" do
      klass = Class.new(ActiveRecord::Migration) { no_nazi }
      klass.new.nazi_disabled?.must_equal true
    end
  end
end
