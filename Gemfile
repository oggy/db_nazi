source :rubygems
gemspec

case ENV['DB_NAZI_ADAPTER']
when 'mysql'
  gem 'mysql'
when 'jdbcmysql'
  gem 'activerecord-jdbcmysql-adapter'
when 'mysql2'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
else
  gem 'sqlite3'
end
