source 'https://rubygems.org'
gem 'ritual'
gem 'minitest', '< 5'
gem 'temporaries'
gemspec

case ENV['DB_NAZI_ADAPTER']
when 'mysql'
  gem 'mysql'
when 'mysql'
  gem 'mysql'
when 'mysql2'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
when 'jdbcmysql'
  gem 'activerecord-jdbcmysql-adapter'
else
  gem 'sqlite3'
end
