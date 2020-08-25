module PFM
  class MonthlySpendingTest < ActiveSupport::TestCase
    setup do
      Rails.configuration.event_store.tap do |store|
        store.subscribe(Query::UpdateMonthlySpending, to: [PFM::TransactionAdded])
      end
    end

    test 'add several transactions' do
      event_store = Rails.configuration.event_store
      monthly_spending = Query::MonthlySpending.new
      monthly_spending.clear_all

      event_store.publish(PFM::TransactionAdded.new(data: { transaction_id: SecureRandom.uuid, amount: -1000, datetime: DateTime.parse('2020-07-01T00:00:00+09:00'), description: 'test', account_from: nil, account_to: nil }))
      event_store.publish(PFM::TransactionAdded.new(data: { transaction_id: SecureRandom.uuid, amount: -1000, datetime: DateTime.parse('2020-07-31T00:00:00+09:00'), description: 'test', account_from: nil, account_to: nil }))
      event_store.publish(PFM::TransactionAdded.new(data: { transaction_id: SecureRandom.uuid, amount: -1000, datetime: DateTime.parse('2020-06-01T00:00:00+09:00'), description: 'test', account_from: nil, account_to: nil }))

      assert_equal(-2000.0, monthly_spending['2020-07'])
      assert_equal(-1000.0, monthly_spending['2020-06'])
      assert_equal(0.0, monthly_spending['2020-05'])
    end
  end
end
