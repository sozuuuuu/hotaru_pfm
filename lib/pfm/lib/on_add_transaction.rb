require 'command_handler'

module PFM
  class OnAddTransaction
    include CommandHandler

    def call(command)
      with_aggregate(Transaction, command.aggregate_id) do |transaction|
        transaction.add(command.amount,
                        command.description,
                        command.account_from,
                        command.account_to,
                        command.datetime)
      end
    end
  end
end
