class CreateCompanyInfos < ActiveRecord::Migration
  def change
    create_table :company_infos do |t|
      t.string :company_name
      t.string :company_address
      t.string :company_phone1
      t.string :company_phone2
      t.string :company_mobile
      t.string :company_fax
      t.string :company_website
      t.string :company_slogan
      t.boolean :company_active
      t.integer :company_created_id
      t.integer :company_updated_id

      t.timestamps
    end
  end
end
