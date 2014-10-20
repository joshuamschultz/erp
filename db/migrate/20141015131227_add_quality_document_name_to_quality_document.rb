class AddQualityDocumentNameToQualityDocument < ActiveRecord::Migration
  def change
    add_column :quality_documents, :quality_document_name, :string
  end
end
