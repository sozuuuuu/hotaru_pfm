class TxnsController < ApplicationController
  def index
    @txns = Query::Transaction.all
    @monthly_spending = Query::MonthlySpending.new.all
  end

  def new
    @txn_id = SecureRandom.uuid
  end

  def create
    schema = Dry::Schema.Params do
      required(:amount).filled(:float)
      required(:description).filled(:string)
      required(:account_from).maybe(:string)
      required(:account_to).maybe(:string)
      required(:datetime).filled(:string)
      required(:transaction_id).filled(:string)
    end

    p = schema.call(params.permit!.to_hash).to_h
    command = PFM::AddTransaction.new(p)
    command_bus.(command)
    redirect_to txns_path, notice: 'Transaction was successfully submitted.'
  end
end
