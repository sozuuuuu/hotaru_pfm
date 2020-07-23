require 'test_helper'
require 'money'

class MoneyTest < ActiveSupport::TestCase
  test 'compare different currencies' do
    jpy = Money.new(amount: -1000, currency: 'JPY')
    usd = Money.new(amount: -1000, currency: 'USD')

    assert_raises Money::IncomparableError do
      jpy == usd
    end
  end
end
