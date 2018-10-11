class AddRepeatsAndDescriptionToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :repeats, :string
    add_column :events, :description, :text
  end
end
