class CreateQuotesOrganizations < ActiveRecord::Migration
  def change
    create_table :quotes_organizations do |t|
    	t.references :organization
      t.references :quote
      t.timestamps
    end
    add_index :quotes_organizations, :quote_id
    add_index :quotes_organizations, :organization_id
  end
end
