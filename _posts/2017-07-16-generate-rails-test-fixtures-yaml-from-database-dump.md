---
layout: post
title: "Generate Rails test fixtures yaml from database dump"
description: "How to generate Ruby on Rails test fixtures yaml files from a development database dump."
categories: [tutorials]
tags: [database, ruby on rails]
redirect_from:
  - /2017/07/16/
---
I came across a problem while working on my little side project [Strafforts][Strafforts]
(A Visualizer for Strava Estimated Best Efforts and Races),
that how to generate Ruby on Rails test fixtures yaml files from a development database dump.

After some Googling, [this article][Script to generate fixtures from a database] gave me directions and therefore made my own version of it.

```ruby
namespace :db do
  desc 'Convert development DB to Rails test fixtures'
  task to_fixtures: :environment do
    TABLES_TO_SKIP = %w[ar_internal_metadata delayed_jobs schema_info schema_migrations].freeze

    begin
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection.tables.each do |table_name|
        next if TABLES_TO_SKIP.include?(table_name)

        conter = '000'
        file_path = "#{Rails.root}/test/fixtures/#{table_name}.yml"
        File.open(file_path, 'w') do |file|
          rows = ActiveRecord::Base.connection.select_all("SELECT * FROM #{table_name}")
          data = rows.each_with_object({}) do |record, hash|
            suffix = record['id'].blank? ? conter.succ! : record['id']
            hash["#{table_name.singularize}_#{suffix}"] = record
          end
          puts "Writing table '#{table_name}' to '#{file_path}'"
          file.write(data.to_yaml)
        end
      end
    ensure
      ActiveRecord::Base.connection.close if ActiveRecord::Base.connection
    end
  end
end
```

Then it can be used just like any other Rake tasks:

    rake db:to_fixtures

All generated `*.yml` files will be fully compaitible with Rails and can be loaded to tests.

```yaml
---
country_1:
  id: 1
  name: New Zealand
  created_at: '2017-02-20 08:56:18.481455'
  updated_at: '2017-02-20 08:56:18.481455'
country_2:
  id: 2
  name: United States
  created_at: '2017-02-20 09:51:23.430189'
  updated_at: '2017-02-20 09:51:23.430189'
country_3:
  id: 3
  name: Deutschland
  created_at: '2017-02-20 09:53:23.819761'
  updated_at: '2017-02-20 09:53:23.819761'
```

[Strafforts]: http://www.strafforts.com/
[Script to generate fixtures from a database]: http://www.austinstory.com/script-to-generate-fixtures-from-a-database/
