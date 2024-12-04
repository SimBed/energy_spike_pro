OCTOPUS_SECRETS = {
  account_number: ENV['OCTOPUS_ACCOUNT_NUMBER'],
  electricity_mpan: ENV['OCTOPUS_ELECTRICITY_MPAN'],
  electricity_meter: ENV['OCTOPUS_ELECTRICITY_METER'],
  gas_mprn: ENV['OCTOPUS_GAS_MPRN'],
  gas_meter: ENV['OCTOPUS_GAS_METER'],
  api_key: ENV['OCTOPUS_API_KEY']
}

TWILIO_SECRETS = {
  account_sid: ENV['TWILIO_ACCOUNT_SID'],
  auth_token: ENV['TWILIO_AUTH_TOKEN'],
  me: ENV['ME'],
  whatsapp_number: ENV['TWILIO_WHATSAPP_NUMBER']
}