class AddRootCauseToQualityAction < ActiveRecord::Migration[5.0]
  def change
  	add_column :quality_actions, :root_cause, :text
  end
end
