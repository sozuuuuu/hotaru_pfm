require 'command_handler'

module PFM
  class OnAddTransaction
    def initialize(event_store)
      @event_store = event_store
    end

    def with_aggregate(aggregate_class, aggregate_id, &block)
      # repository = AggregateRoot::InstrumentedRepository.new(AggregateRoot::Repository.new(Rails.configuration.event_store), ActiveSupport::Notifications)
      aggregate = aggregate_class.new(aggregate_id, event_store: @event_store)
      stream = stream_name(aggregate_class, aggregate_id)
      events = @event_store.read.stream(stream).to_a
      events.each { |event| aggregate.apply(event) }
      block.call(aggregate)
    end

    # def rehydrate(aggregate, stream)
    #   repository = AggregateRoot::InstrumentedRepository.new(AggregateRoot::Repository.new(Rails.configuration.event_store), ActiveSupport::Notifications)
    #   repository.load(aggregate, stream)
    # end

    def stream_name(aggregate_class, aggregate_id)
      "#{aggregate_class.name}$#{aggregate_id}"
    end

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
