require 'command'
require 'types'

module PFM
  class AddAccount < Command
    attribute :account_id, Types::UUID
    attribute :name, Types::String

    alias aggregate_id account_id
  end
end
