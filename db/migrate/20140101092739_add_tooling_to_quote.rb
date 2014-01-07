class AddToolingToQuote < ActiveRecord::Migration
  def change
  	add_column :quote_line_costs, :quote_line_cost_tooling, :decimal, :precision => 25, :scale => 10, :default => 0
  	add_column :quote_line_costs, :quote_line_cost_lead, :string
  	add_column :quote_line_costs, :quote_line_cost_description, :string
  end
end
