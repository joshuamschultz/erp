class AddGroupIdToQuote < ActiveRecord::Migration
	def change
		add_column :quotes, :group_id, :integer
		
		add_index :quotes, :group_id
	end
end
