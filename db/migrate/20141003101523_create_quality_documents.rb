class CreateQualityDocuments < ActiveRecord::Migration
  def change
    create_table :quality_documents do |t|

      t.timestamps
    end
  end
end
