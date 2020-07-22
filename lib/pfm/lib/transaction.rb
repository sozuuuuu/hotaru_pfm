module PFM
  class Transaction
    include AggregateRoot

    def initialize(id)
      @id = id
      @amount = 0.0
    end

    def add(amount, description, account_from, account_to, datetime)
      apply TransactionAdded.new(data: { transaction_id: @id,
                                         amount: amount,
                                         description: description,
                                         account_from: account_from,
                                         account_to: account_to,
                                         datetime: datetime})
    end

    on TransactionAdded do |event|
      @amount = event.data[:amount]
      @description = event.data[:description]
      @account_from = event.data[:account_from]
      @account_to = event.data[:account_to]
      @datetime = event.data[:datetime]
    end
  end
end
