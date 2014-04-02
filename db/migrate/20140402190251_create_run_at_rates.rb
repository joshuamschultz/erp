class CreateRunAtRates < ActiveRecord::Migration
  def change
    create_table :run_at_rates do |t|
      t.string :run_at_rate_name
      t.string :run_at_rate_description
      t.text :run_at_rate_notes
      t.boolean :run_at_rate_active
      t.integer :run_at_rate_created_id
      t.integer :run_at_rate_updated_id

      t.timestamps
    end
  end
end
