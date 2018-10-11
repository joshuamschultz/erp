class AddQualityDocumentIdToMasterType < ActiveRecord::Migration[5.0]
  def change
    add_column :master_types, :master_type, :string
    add_column :master_types, :quality_document_id, :integer
  end
end
