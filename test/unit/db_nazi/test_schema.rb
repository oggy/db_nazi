require_relative '../../test_helper'

describe DBNazi::Schema do
  use_database

  # Migrations use Kernel.puts. Lame.
  out = Class.new { def puts(*); end; def write(*) end; def flush(*) end }.new
  use_global_value :stdout, out

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
