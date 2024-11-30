class ConsumptionController < ApplicationController
  def get
    octopus_initialize
    set_urls

    @json_response_results_leccy = get_results(@url_leccy) # array of hashes
    todays_leccy_consumption = @json_response_results_leccy.first['consumption']
    @results_leccy = results_process(@json_response_results_leccy)
    @alert_leccy = todays_leccy_consumption > 0.29

    @json_response_results_gas = get_results(@url_gas)
    todays_gas_consumption = @json_response_results_gas.first['consumption']
    @results_gas = results_process(@json_response_results_gas)
    # https://andycroll.com/ruby/calculate-a-mean-average-from-a-ruby-array/
    week_gas_average = (@results_gas.values.sum(0.0) / @results_gas.values.size)
    @alert_gas = todays_gas_consumption > 1.2 * week_gas_average

    date_yesterday = Time.zone.now.yesterday.strftime('%A, %d %B')
    send_warning(date_yesterday, 0.29.to_s, todays_leccy_consumption.round(2).to_s, week_gas_average.round(2).to_s, todays_gas_consumption.round(2).to_s) # if @alert_leccy || @alert_gas
    # send_warning('Monday, 14 Jan', '2.0', '2.5', '1.5', '2.0') if @alert_leccy || @alert_gas
  end

  private

  def octopus_initialize
    @account_number = Rails.configuration.octopus[:account_number]
    @electricity_mpan = Rails.configuration.octopus[:electricity_mpan]
    @electricity_meter = Rails.configuration.octopus[:electricity_meter]
    @gas_mprn = Rails.configuration.octopus[:gas_mprn]
    @gas_meter = Rails.configuration.octopus[:gas_meter]
    @api_key = Rails.configuration.octopus[:api_key]
  end

  def set_urls
    period_from = Time.zone.now.advance(days: -7).strftime('%Y-%m-%dT00:00:00Z')
    period_to = Time.zone.now.yesterday.strftime('%Y-%m-%dT23:59:59Z')
    @url_leccy = "https://api.octopus.energy/v1/electricity-meter-points/#{@electricity_mpan}/meters/#{@electricity_meter}/" \
                 "consumption?period_from=#{period_from}&period_to=#{period_to}&group_by=day"
    @url_gas = "https://api.octopus.energy/v1/gas-meter-points/#{@gas_mprn}/meters/#{@gas_meter}/" \
               "consumption?period_from=#{period_from}&period_to=#{period_to}&group_by=day"
  end

  def get_results(url)
    response = HTTParty.get(url, { basic_auth: { username: @api_key, password: '' } })
    json_response = JSON.parse(response.body)
    json_response['results']
  end

  def results_process(response)
    results = {}
    response.each { |r| results[Date.parse(r['interval_start']).strftime('%d %b %y')] = r['consumption'] }
    results # results becomes a hash with keys all the period dates and value consumption
  end

  def send_warning(date, leccy_normal, leccy_actual, gas_average, gas_actual)
    TwilioMessage.new(content_sid: 'HX1a9baa0af51441b2e3ab2329c7e72804',
                      content_variables: { '1': date,
                                           '2': leccy_normal,
                                           '3': leccy_actual,
                                           '4': gas_average,
                                           '5': gas_actual }).manage
  end
end
