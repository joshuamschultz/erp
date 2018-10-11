class AddCustomerToReceivable < ActiveRecord::Migration[5.0]
  def change
  		add_column :receivables, :receivable_invoice, :string
  end
end
