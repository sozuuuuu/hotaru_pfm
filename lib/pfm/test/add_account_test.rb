require_relative './test_helper'

module PFM
  class AddAccountTest < ActiveSupport::TestCase
    include TestCase

    # What is this?
    cover 'PFM::AddAccount*'

    setup do
      Rails.configuration.command_bus.tap do |bus|
        bus.register(PFM::AddAccount, PFM::OnAddAccount.new)
      end
    end

    test 'account is added' do
      aggregate_id = SecureRandom.uuid
      stream = "PFM::Account$#{aggregate_id}"
      published = act(stream, AddAccount.new(account_id: aggregate_id, name: '普通'))
      assert_changes(published, [AccountAdded.new(data: {account_id: aggregate_id, order_id: aggregate_id, name: '普通'})])
    end
  end
end
