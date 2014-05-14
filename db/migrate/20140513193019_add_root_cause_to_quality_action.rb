class AddRootCauseToQualityAction < ActiveRecord::Migration
  def change
  	add_column :quality_actions, :root_cause, :text
  end
end
