require 'money'

module PFM
  class Transaction
    class DuplicatedTransactionError < StandardError; end

    def initialize(id)
      @id = id
      @amount = Money.new(amount: 0.0)
    end

    def add(amount, description, account_from, account_to, datetime)
      raise DuplicatedTransactionError if @state == :created

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

      event
    end

    def stream_name
      "#{self.class}$#{@id}"
    end

    def on_transaction_added(_event)
      @state = :created
    end
  end
end
