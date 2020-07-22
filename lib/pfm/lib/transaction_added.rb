require 'event'

module PFM
  class TransactionAdded < Event
    attribute :transaction_id, Types::UUID
    attribute :amount, Types::Coercible::Float
    attribute :description, Types::String
    attribute :account_from, Types::UUID.optional
    attribute :account_to, Types::UUID.optional
    attribute :datetime, Types::DateTime
  end
end
