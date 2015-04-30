class AddQuoteIdToCustomerQuoteLine < ActiveRecord::Migration
  def change
    add_column :customer_quote_lines, :quote_id, :integer
  end
end
