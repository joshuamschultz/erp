class AddRepeatsAndDescriptionToEvent < ActiveRecord::Migration
  def change
    add_column :events, :repeats, :string
    add_column :events, :description, :text
  end
end
