class AddCustomerToReceivable < ActiveRecord::Migration
  def change
  		add_column :receivables, :receivable_invoice, :string
  end
end
