## DB Nazi

Encourages good DB practices in Active Record migrations.

## What?

Active Record makes schema changes wonderfully easy, but due to some unfortunate
defaults, it can be easy to forget to adhere to some basic database best
practices, such as restricting columns to be non-nullable, or setting meaningful
varchar limits. DB Nazi forces you to be explicit about these things so you
can't simply forget.

It might take another 2 seconds to type `null: true`, but it may save you hours
resolving integrity issues down the line!

### Nullability

If `DBNazi.require_nullability` is set to `true` (the default), you must specify
a `:null` option for all columns.

    add_column :users, :awesome, :boolean              # raises DBNazi::NullabilityRequired
    add_column :users, :awesome, :boolean, null: true  # ok

### Varchar limits

If `DBNazi.require_varchar_limits` is set to `true` (the default), you must
specify a `:limit` option for all `:string` columns.

    add_column :users, :name, :string              # raises DBNazi::VarcharLimitRequired
    add_column :users, :name, :string, limit: 100  # ok

### Index uniqueness

If `DBNazi.require_index_uniqueness` is set the `true` (the default), you must
specify a `:unique` option for all indexes.

    add_index :users, :email                 # raises DBNazi::IndexUniquenessRequired
    add_index :users, :email, unique: false  # ok

## Usage

Since this tool is about enforcing developer discipline, I suggest including
this only in the `:development` group in your `Gemfile`.

    group :development do
      gem 'db_nazi'
    end

If you have an established project, you probably don't want to lay the hard line
on all your existing migrations. You can do this by specifying a minimum
migration version in `config/environments/development.rb`:

    DBNazi.from_version = 20120623000000

This means "only be a nazi from migration 20120623000000 onwards."

If you're using a migration written by a 3rd party, such as a generator you're
using, I recommend editing it to conform to the rules above. After all, perhaps
the 3rd party forgot a 'NOT NULL' or two.

If you're *really* sure you want to subvert DB Nazi for whatever reason, you may
do so like this:

    class BeAJerk < ActiveRecord::Migration
      no_nazi
      ...
    end

Or just for a given block like this:

    DBNazi.disable do
      ...
    end

But no soup for you!

## Contributing

 * [Bug reports](https://github.com/oggy/db_nazi/issues)
 * [Source](https://github.com/oggy/db_nazi)
 * Patches: Fork on Github, send pull request.
   * Include tests where practical.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) George Ogata. See LICENSE for details.
