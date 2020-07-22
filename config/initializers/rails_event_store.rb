require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

require 'pfm/pfm'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  # Subscribe event handlers below
  # Rails.configuration.event_store.tap do |store|
  #   store.subscribe(InvoiceReadModel.new, to: [InvoicePrinted])
  #   store.subscribe(->(event) { SendOrderConfirmation.new.call(event) }, to: [OrderSubmitted])
  #   store.subscribe_to_all_events(->(event) { Rails.logger.info(event.type) })
  # end

  # Register command handlers below
  # Rails.configuration.command_bus.tap do |bus|
  #   bus.register(PrintInvoice, Invoicing::OnPrint.new)
  #   bus.register(SubmitOrder,  ->(cmd) { Ordering::OnSubmitOrder.new.call(cmd) })
  # end

  unless Rails.env.test?
    Rails.configuration.event_store.tap do |store|
      store.subscribe(Query::UpdateMonthlySpending, to: [PFM::TransactionAdded])
      store.subscribe(Query::CreateTransactionView, to: [PFM::TransactionAdded])
    end

    Rails.configuration.command_bus.tap do |bus|
      bus.register(PFM::AddAccount, PFM::OnAddAccount.new)
      bus.register(PFM::AddTransaction, PFM::OnAddTransaction.new)
    end
  end
end
