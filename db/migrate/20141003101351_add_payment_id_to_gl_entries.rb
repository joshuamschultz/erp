class AddPaymentIdToGlEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :gl_entries, :payment_id, :integer
  end
end
