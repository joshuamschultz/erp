class CreateCompanyInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :company_infos do |t|
      t.string :company_name
      t.text :company_address1
      t.text :company_address2
      t.string :company_phone1
      t.string :company_phone2
      t.string :company_mobile
      t.string :company_fax
      t.string :company_website
      t.string :company_slogan
      t.boolean :company_active

      t.timestamps
    end
  end
end
