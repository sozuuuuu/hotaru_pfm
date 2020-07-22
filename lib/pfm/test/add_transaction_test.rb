require_relative './test_helper'

module PFM
  class AddTransactionTest < ActiveSupport::TestCase
    include TestCase

    # What is this?
    cover 'PFM::AddTransaction*'

    setup do
      Rails.configuration.command_bus.tap do |bus|
        bus.register(PFM::AddTransaction, PFM::OnAddTransaction.new)
      end
    end

    test 'transaction is added' do
      aggregate_id = SecureRandom.uuid
      stream = "PFM::Transaction$#{aggregate_id}"
      acc_x = SecureRandom.uuid
      acc_y = SecureRandom.uuid
      datetime = DateTime.parse('2020-07-22T00:00:00+09:00')
      command = AddTransaction.new(transaction_id: aggregate_id,
                                   amount: -1000.0,
                                   datetime: datetime,
                                   description: 'test',
                                   account_from: acc_x,
                                   account_to: acc_y)

      published_events = act(stream, command)
      assert_equal(1, published_events.length)

      event = published_events.first
      assert_equal(aggregate_id, event.data[:transaction_id])
      assert_equal(-1000.0, event.data[:amount])
      assert_equal(acc_x, event.data[:account_from])
      assert_equal(acc_y, event.data[:account_to])
      assert_equal(datetime, event.data[:datetime])
    end
  end
end
