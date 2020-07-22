class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.datetime :datetime, null: false
      t.string :description, null: false
      t.float :amount, null: false
      t.string :uid, null: false
      t.string :account_from
      t.string :account_to
    end
  end
end
