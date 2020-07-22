module Query
  class UpdateMonthlySpending
    def call(event)
      datetime = event.data[:datetime]
      amount = event.data[:amount]
      MonthlySpending.new.add(datetime.to_date, amount)
    end
  end
end
