class AddReceivableDisperseToReceivable < ActiveRecord::Migration[5.0]
  def change
    add_column :receivables, :receivable_disperse, :string
  end
end
