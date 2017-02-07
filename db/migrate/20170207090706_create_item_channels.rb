class CreateItemChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :item_channels do |t|
      t.integer :item_revision_id
      t.string :channel
      t.string :channel_item_id

      t.timestamps
    end
  end
end
