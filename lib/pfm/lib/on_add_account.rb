require 'command_handler'

module PFM
  class OnAddAccount
    include CommandHandler

    def call(command)
      with_aggregate(Account, command.aggregate_id) do |account|
        account.add(command.name)
      end
    end
  end
end
