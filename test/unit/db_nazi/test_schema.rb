require_relative '../../test_helper'

describe DBNazi::Schema do
  use_database
  silence_stdout

  describe ".define" do
    it "should not be policed" do
      ActiveRecord::Schema.define(:version => 1) do
        create_table 'test_table' do |t|
          t.boolean :test_column
        end
      end
    end
  end
end
