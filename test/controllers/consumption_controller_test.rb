require 'test_helper'

class ConsumptionControllerTest < ActionDispatch::IntegrationTest
  test 'should get get' do
    get consumption_get_url

    assert_response :success
  end
end
