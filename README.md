# actor_sync
Automatically synchronise actor information to your third party systems e.g. Mixpanel, Sendgrid, Segment etc.

## Getting Started
`config/initializers/actor_sync.rb`

```ruby
ActorSync.configure do |config|
   config.sync = true
   config.mixpanel = { api_key: '' }
   config.mailchimp = { api_key: '' }
end


class User < ApplicationRecord
   include ActorSync

   actor_sync :mixpanel, user_profile: true
   actor_sync :mailchimp, audience: monthly_mailing_lists

   def data_to_export_to_mixpanel
      {
         '$first_name': profile.first_name,
         '$last_name': profile.last_name,
         '$email': email
      }
   end
end

class Company < ApplicationRecord
   include ActorSync

   actor_sync :mixpanel, group_profile: true

   def data_to_export_to_mixpanel
      {
         '$name': name,
         'products': products_count
      }
   end
end

```



# TODO
- Add Intercom
