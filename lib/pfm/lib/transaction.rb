require 'money'

module PFM
  class Transaction
    def initialize(id, event_store:)
      @id = id
      @amount = Money.new(amount: 0.0)
      @event_store = event_store
    end

    def add(amount, description, account_from, account_to, datetime)
      apply TransactionAdded.new(data: { transaction_id: @id,
                                         amount: amount,
                                         description: description,
                                         account_from: account_from,
                                         account_to: account_to,
                                         datetime: datetime })
    end

    class UnhandledEventError < StandardError; end

    def apply(event)
      case event
      when TransactionAdded
        on_transaction_added(event)
      else
        raise UnhandledEventError, event
      end

      @event_store.publish(event, stream_name: stream_name)
    end

    def stream_name
      "#{self.class}$#{@id}"
    end

    def on_transaction_added(_event); end
  end
end
