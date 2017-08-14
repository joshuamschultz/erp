class AddRevisionToSpecifications < ActiveRecord::Migration[5.0]
  def change
    add_column :specifications, :revision, :string
    add_column :specifications, :revision_date, :date
  end
end
