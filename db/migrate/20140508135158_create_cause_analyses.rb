class CreateCauseAnalyses < ActiveRecord::Migration
  def change
    create_table :cause_analyses do |t|
      t.string :name
      t.string :description
      t.text :notes
      t.boolean :active
      t.integer :created_id
      t.integer :updated_id

      t.timestamps
    end
  end
end
