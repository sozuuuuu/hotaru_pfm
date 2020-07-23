class Money
  def initialize(amount:, currency: 'JPY')
    @amount = amount
    @currency = currency
  end

  IncomparableError = Class.new(StandardError)

  attr_reader :currency, :amount

  def to_i
    @amount
  end

  def to_s
    "#{@amount} (#{@currency})"
  end

  def ==(other)
    raise IncomparableError, "You cannot compare different currencies" if currency != other.currency

    amount == other.amount
  end
end
