module Query
  class MonthlySpending
    def add(date, amount)
      year_month = "#{date.year}-#{date.month.to_s.rjust(2, '0')}"
      store.incrbyfloat(year_month, amount)
    end

    def clear_all
      store.clear
    end

    def store
      @store ||= Redis::HashKey.new('monthly_spending')
    end

    def all
      store.all.map { |k, v| { date: k, amount: v } }
    end

    def [](key)
      store.[](key).to_f
    end
  end
end
