class CreateGlTypes < ActiveRecord::Migration
  def change
    create_table :gl_types do |t|
      t.string :gl_name
      t.string :gl_side
      t.string :gl_report
      t.string :gl_identifier
      t.string :gl_description
      t.boolean :gl_active

      t.timestamps
    end
  end
end
