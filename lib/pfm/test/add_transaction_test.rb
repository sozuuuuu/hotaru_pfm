require_relative './test_helper'

module PFM
  class AddTransactionTest < ActiveSupport::TestCase
    setup do
      @event_store = RailsEventStore::Client.new(
        repository: RubyEventStore::InMemoryRepository.new
      )
      @command_bus = Arkency::CommandBus.new
      @command_bus.register(
        PFM::AddTransaction,
        PFM::OnAddTransaction.new(@event_store)
      )
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

      before = @event_store.read.stream(stream).each.to_a
      @command_bus.(command)
      after = @event_store.read.stream(stream).each.to_a
      published_events = after.reject { |a| before.any? { |b| a.event_id == b.event_id } }

      assert_equal(1, published_events.length)

      event = published_events.first
      assert_equal(aggregate_id, event.data[:transaction_id])
      assert_equal(-1000.0, event.data[:amount])
      assert_equal(acc_x, event.data[:account_from])
      assert_equal(acc_y, event.data[:account_to])
      assert_equal(datetime, event.data[:datetime])
    end

    test 'transaction is added twice' do
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

      before = @event_store.read.stream(stream).each.to_a
      @command_bus.(command)
      after = @event_store.read.stream(stream).each.to_a
      published_events = after.reject { |a| before.any? { |b| a.event_id == b.event_id } }

      assert_equal(1, published_events.length)

      event = published_events.first
      assert_equal(aggregate_id, event.data[:transaction_id])
      assert_equal(-1000.0, event.data[:amount])
      assert_equal(acc_x, event.data[:account_from])
      assert_equal(acc_y, event.data[:account_to])
      assert_equal(datetime, event.data[:datetime])

      # run the command again
      # should not create an event with the same event_id as previous event
      # should not create a new transaction since the aggregate_id is duplicated
      assert_raise PFM::Transaction::DuplicatedTransactionError do
        @command_bus.(command)
      end
    end
  end
end
