# Actor Sync
Automatically synchronise actor information to your third party systems e.g. Mixpanel, Sendgrid, Segment etc. 

## Getting Started
`config/initializers/actor_sync.rb`

```ruby
ActorSync.configure do |config|
   config.sync = true
   config.mixpanel = { project_token: '' }
   config.mailchimp = { api_key: '' }
end
```

`app/models/user.rb`
```ruby
class User < ApplicationRecord
   include ActorSync

   actor_sync :mixpanel
   actor_sync :mailchimp, audience: monthly_mailing_lists

   def data_to_export_to_mixpanel
      {
         '$first_name': profile.first_name,
         '$last_name': profile.last_name,
         '$email': email
      }
   end
end
```

`app/models/company.rb`
```ruby
class Company < ApplicationRecord
   include ActorSync

   actor_sync :mixpanel, group: true

   def data_to_export_to_mixpanel
      {
         '$name': name,
         'products': products_count
      }
   end
end

```

# TODO
- Write more tests.
- Add Instrumentation
- Add support for other activejob backends - Resque etc.
- Add support for NoSQL Databases
- Add support for Sinatra (Non-Rails environment)
- More documentation
- Add rake tasks to manually sync data
- Add support for mixpanel lookup tables
