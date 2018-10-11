class AddQuoteIdToCustomerQuoteLine < ActiveRecord::Migration[5.0]
  def change
    add_column :customer_quote_lines, :quote_id, :integer
  end
end
