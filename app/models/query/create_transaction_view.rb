module Query
  class CreateTransactionView
    def call(event)
      datetime = event.data[:datetime]
      amount = event.data[:amount]
      description = event.data[:description]
      account_from = event.data[:account_from]
      account_to = event.data[:account_to]
      uid = event.data[:transaction_id]

      Query::Transaction.create!(datetime: datetime, amount: amount, description: description, account_from: account_from, account_to: account_to, uid: uid)
    end
  end
end
