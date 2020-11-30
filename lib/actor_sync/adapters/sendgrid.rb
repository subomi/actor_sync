# frozen_string_literal: true

class Sendgrid
  def initialize(actor)
    @actor = actor
  end

  def send
    sg = Sendgrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    sg.client.marketing.contacts.put(request_body: data)
  end

  def data
    @actor.data_to_sendgrid
  end
end
