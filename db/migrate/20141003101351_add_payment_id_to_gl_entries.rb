class AddPaymentIdToGlEntries < ActiveRecord::Migration
  def change
    add_column :gl_entries, :payment_id, :integer
  end
end
