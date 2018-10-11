class AddGroupIdToQuote < ActiveRecord::Migration[5.0]
	def change
		add_column :quotes, :group_id, :integer
		
		add_index :quotes, :group_id
	end
end
