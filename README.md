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

   actor_sync :mixpanel
   actor_sync :mailchimp, audience: monthly_mailing_lists

   def data_to_export_to_mixpanel
      ['email', 'profile.firstname', 'profile.lastname']
   end
end

```



# TODO
- Add Intercom
