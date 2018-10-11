class AddQualityDocumentNameToQualityDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :quality_documents, :quality_document_name, :string
  end
end
