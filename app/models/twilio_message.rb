class TwilioMessage
  def initialize(attributes = {})
    @content_sid = attributes[:content_sid]
    @content_variables = attributes[:content_variables] || {}
  end

  def manage
    return unless whatsapp_permitted

    send_whatsapp
  end

  def send_whatsapp
    twilio_initialise
    client = Twilio::REST::Client.new(@account_sid, @auth_token)
    client.api.v2010.messages.create(
      content_sid: @content_sid,
      to: "whatsapp:#{@to_number}",
      from: "whatsapp:#{@from_number}",
      content_variables: @content_variables.to_json
    )
  end

  private

  def twilio_initialise
    @account_sid = Rails.configuration.twilio[:account_sid]
    @auth_token = Rails.configuration.twilio[:auth_token]
    @from_number = Rails.configuration.twilio[:whatsapp_number]
    @to_number = Rails.configuration.twilio[:me]
  end

  def whatsapp_permitted
    return true if Rails.env.production?

    true
  end
end
