module PFM
end

# Commands
require_relative 'lib/add_account'
require_relative 'lib/add_transaction'

# Command handlers
require_relative 'lib/on_add_account'
require_relative 'lib/on_add_transaction'

# Events
require_relative 'lib/account_added'
require_relative 'lib/transaction_added'

# Aggregates
require_relative 'lib/account'
require_relative 'lib/transaction'
