class AddReceivableDisperseToReceivable < ActiveRecord::Migration
  def change
    add_column :receivables, :receivable_disperse, :string
  end
end
