require 'command'
require 'types'

module PFM
  class AddTransaction < Command
    attribute :transaction_id, Types::UUID
    attribute :description, Types::String
    attribute :amount, Types::Coercible::Float
    attribute :account_from, Types::UUID.optional
    attribute :account_to, Types::UUID.optional
    attribute :datetime, Types::DateTime

    alias aggregate_id transaction_id
  end
end
