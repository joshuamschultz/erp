class CreateQualityDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :quality_documents do |t|

      t.timestamps
    end
  end
end
