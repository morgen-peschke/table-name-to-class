Table Name to Class: Because we all do odd things
=================================================

Converting table names to the relevant class in a Rails App should be easy
right? This _should_ do the trick:
```ruby
'some_table'.classify.constantize # => SomeTable
```

Life is often not quite that kind, and name-spacing is an awesome organizational
tool ... that completely breaks the nice, simple, straightforward way of doing
things.

So we get a bit smarter, and a bit more clever, and either end up with something
very close to this gem - which exists so you don't have to.

TL;DR
-----

Makes class names out of database table names.

Install
-------

### Global
```bash
gem install table-name-to-class
```

### Gemfile
```ruby
gem gem 'table-name-to-class'
```

Basic Usage
-----------

```ruby
require 'table-name-to-class'
```

```ruby
TableNameToClass.convert "some_table_name"   # => SomeTableName
TableNameToClass.convert "nonexistant_table" # => nil
TableNameToClass.convert "namespaced_table"  # => Namespaced::Table
```

The initial load is a mite expensive, but only has to be done once, if you need
to force a reload for whatever reason, here's how to do it:

```ruby
TableNameToClass.convert "table_name", true
```

If something weird is happening, the hashed conversion is available for
inspection/modification.

```ruby
TableNameToClass.debug # => Hash(probably huge) of "table_name" => ClassConstant
```
