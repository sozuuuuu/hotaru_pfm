module PFM
  class Account
    include AggregateRoot

    def initialize(id)
      @id = id
      @name = ''
    end

    def add(name)
      apply AccountAdded.new(data: { account_id: @id, name: name })
    end

    on AccountAdded do |event|
      @name = event.data[:name]
    end
  end
end
