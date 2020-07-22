require 'event'

module PFM
  class AccountAdded < Event
    attribute :account_id, Types::UUID
    attribute :name, Types::String
  end
end
